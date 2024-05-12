package keeper

import (
	"github.com/parvuli/communio/x/communio/types"
)

var _ types.QueryServer = Keeper{}
