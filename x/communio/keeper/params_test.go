package keeper_test

import (
	"testing"

	"github.com/stretchr/testify/require"

	keepertest "github.com/parvuli/communio/testutil/keeper"
	"github.com/parvuli/communio/x/communio/types"
)

func TestGetParams(t *testing.T) {
	k, ctx := keepertest.CommunioKeeper(t)
	params := types.DefaultParams()

	require.NoError(t, k.SetParams(ctx, params))
	require.EqualValues(t, params, k.GetParams(ctx))
}
