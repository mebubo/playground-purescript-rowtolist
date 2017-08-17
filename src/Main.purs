module Main where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Prelude (Unit, show, ($), (>))
import Stringify (stringify)
import Type.Row (class ListToRow, class RowToList, Cons, Nil, kind RowList)

foreign import applyRecord :: forall io i o. ApplyRecord io i o => Record io -> Record i -> Record o

class ApplyRecord (io :: # Type) (i :: # Type) (o :: # Type) | io -> i o, i -> io o, o -> io i

instance applyRecordImpl
  :: ( RowToList io lio
     , RowToList i li
     , RowToList o lo
     , ApplyRowList lio li lo
     , ListToRow lio io
     , ListToRow li i
     , ListToRow lo o)
  => ApplyRecord io i o

class ApplyRowList (io :: RowList) (i :: RowList) (o :: RowList) | io -> i o, i -> io o, o-> io i

instance nilApplyRowList :: ApplyRowList Nil Nil Nil
instance consApplyRowList :: ApplyRowList tio ti to => ApplyRowList (Cons k (i -> o) tio) (Cons k i ti) (Cons k o to)

foo :: {a :: Boolean -> String, b :: Int -> Boolean}
foo = {a: show, b: (_ > 0)}

bar :: {a :: Boolean, b :: Int}
bar = {a: true, b: 0}

x :: { a :: String, b :: Boolean }
x = applyRecord foo bar

main :: forall eff. Eff ( console :: CONSOLE | eff ) Unit
main = do
  log $ stringify x
