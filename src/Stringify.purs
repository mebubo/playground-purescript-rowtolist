module Stringify where

import Control.Monad.Eff.Console

import Control.Monad.Eff (Eff)
import Global.Unsafe (unsafeStringify)
import Prelude (Unit, discard)
import Type.Row (kind RowList, class RowToList, Nil, Cons)

-- Let's give a type to the JSON.stringify function.
-- We can use unsafeStringify, but constrain the input using a new type class
stringify :: forall json. Stringify json => json -> String
stringify = unsafeStringify

-- Let's provide instances for primitive types and arrays
class Stringify json
instance strigdifyBoolean :: Stringify Boolean
instance stringifyChar :: Stringify Char
instance stringifyString :: Stringify String
instance stringifyNumber :: Stringify Number
instance stringifyInt :: Stringify Int
instance stringifyArray :: Stringify json => Stringify (Array json)

-- But now in 0.11.6, we can provide an instance for records too, and
-- require that all fields also have the Stringify constraint,
-- by turning the row of fields into a list using RowToList, and
-- constraining the result with a new type class, StringifyFields.
instance stringifyRecord :: (RowToList r fields, StringifyFields fields) => Stringify (Record r)


class StringifyFields (r :: RowList)
instance stringifyCons :: (Stringify h, StringifyFields t) => StringifyFields (Cons l h t)
instance stringifyNil :: StringifyFields Nil

main :: forall eff. Eff (console :: CONSOLE | eff) Unit
main = do
  log (stringify 42)
  log (stringify "Hello, World!")
  log (stringify [1, 2, 3])
  log (stringify { x: 42, y: 3.14, z: "test" })
  log (stringify { nested: { x: 42 } })
  -- Non-instances give an error:
  -- log (stringify { fn: \x -> x })
