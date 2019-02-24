module Optics.Internal.IxFold where

import Data.Functor
import Data.Foldable

import Optics.Internal.Bi
import Optics.Internal.Indexed
import Optics.Internal.Profunctor
import Optics.Internal.Optic
import Optics.Internal.Fold

-- | Internal implementation of 'mkIxFold'.
mkIxFold__
  :: (Bicontravariant p, Traversing p)
  => (forall f. Applicative f => (i -> a -> f u) -> s -> f v)
  -> Optic__ p j (i -> j) s t a b
mkIxFold__ f = rphantom . iwander f . rphantom
{-# INLINE mkIxFold__ #-}

-- | Internal implementation of 'ifolded'.
ifolded__
  :: (Bicontravariant p, Traversing p, FoldableWithIndex i f)
  => Optic__ p j (i -> j) (f a) t a b
ifolded__ = conjoined' (mkFold__ traverse_) (mkIxFold__ itraverse_)
{-# INLINE ifolded__ #-}

-- | Internal implementation of 'ifoldring'.
ifoldring__
  :: (Bicontravariant p, Traversing p)
  => (forall f. Applicative f => (i -> a -> f u -> f u) -> f v -> s -> f w)
  -> Optic__ p j (i -> j) s t a b
ifoldring__ fr = mkIxFold__ $ \f -> void . fr (\i a -> (f i a *>)) (pure v)
  where
    v = error "ifoldring__: value used"
{-# INLINE ifoldring__ #-}
