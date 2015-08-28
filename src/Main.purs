module Main where

import Prelude

import Control.Apply ((*>))
import Control.Monad.Aff (Aff(), runAff, later')
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Exception (throwException)

import Data.Functor (($>))

import Halogen
import Halogen.Query.StateF (modify)
import Halogen.Util (appendToBody)
import qualified Halogen.HTML as H
import qualified Halogen.HTML.Events as E
import qualified Halogen.HTML.Events.Forms as E
import qualified Halogen.HTML.Properties as P

-- | The state of the application
newtype State = State
  {
    on :: Boolean,
    lyrics :: String,
    phonemes :: String
  }

initialState :: State
initialState = State
  {
    on: false,
    lyrics: "I love you",
    phonemes: ""
  }

-- | Inputs to the state machine
data Input a =
  ToggleState a |
  Play a |
  UpdateLyrics String a

ui :: forall g p. (Functor g) => Component State Input g p
ui = component render eval
  where
  render :: Render State Input p
  render (State state) = H.div_
    [ H.h1_ [ H.text "Toggle Button" ]
    , H.textarea [P.value state.lyrics, E.onValueChange (E.input UpdateLyrics)]
    , H.button [ E.onClick (E.input_ Play)]
               [ H.text "Play"]
    , H.button [ E.onClick (E.input_ ToggleState) ]
               [ H.text (if state.on then "On" else "Off") ]
    , H.p [P.class_ (H.className "phonemes")] [H.text state.phonemes]
    ]

  eval :: Eval Input State Input g
  eval (ToggleState next) = modify (\(State state) -> State (state { on = not state.on })) $> next
  eval (UpdateLyrics textInput next) = modify (\(State state) -> State (state { lyrics = textInput })) $> next
  eval (Play next) = modify (\(State state)
    -> State (state
      {
        on = not state.on,
        phonemes = state.lyrics ++ " Oh Yeahh!"
      })) $> next


main :: Eff (HalogenEffects ()) Unit
main = runAff throwException (const (pure unit)) $ do
  app <- runUI ui initialState
  appendToBody app.node
