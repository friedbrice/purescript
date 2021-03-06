module Language.PureScript.TypeClassDictionaries where

import "base-compat" Prelude.Compat

import "base" GHC.Generics (Generic)
import "deepseq" Control.DeepSeq (NFData)
import "text" Data.Text (Text, pack)

import "this" Language.PureScript.Names
import "this" Language.PureScript.Types

--
-- Data representing a type class dictionary which is in scope
--
data TypeClassDictionaryInScope v
  = TypeClassDictionaryInScope {
    -- | The instance chain
      tcdChain :: [Qualified Ident]
    -- | Index of the instance chain
    , tcdIndex :: Integer
    -- | The value with which the dictionary can be accessed at runtime
    , tcdValue :: v
    -- | How to obtain this instance via superclass relationships
    , tcdPath :: [(Qualified (ProperName 'ClassName), Integer)]
    -- | The name of the type class to which this type class instance applies
    , tcdClassName :: Qualified (ProperName 'ClassName)
    -- | Quantification of type variables in the instance head and dependencies
    , tcdForAll :: [(Text, SourceType)]
    -- | The kinds to which this type class instance applies
    , tcdInstanceKinds :: [SourceType]
    -- | The types to which this type class instance applies
    , tcdInstanceTypes :: [SourceType]
    -- | Type class dependencies which must be satisfied to construct this dictionary
    , tcdDependencies :: Maybe [SourceConstraint]
    }
    deriving (Show, Functor, Foldable, Traversable, Generic)

instance NFData v => NFData (TypeClassDictionaryInScope v)

type NamedDict = TypeClassDictionaryInScope (Qualified Ident)

-- | Generate a name for a superclass reference which can be used in
-- generated code.
superclassName :: Qualified (ProperName 'ClassName) -> Integer -> Text
superclassName pn index = runProperName (disqualify pn) <> pack (show index)
