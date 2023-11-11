Return-Path: <live-patching+bounces-42-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF3B7E88EC
	for <lists+live-patching@lfdr.de>; Sat, 11 Nov 2023 04:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97F6C1F20F31
	for <lists+live-patching@lfdr.de>; Sat, 11 Nov 2023 03:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F090A3C0B;
	Sat, 11 Nov 2023 03:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AOPVxStz"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8FE5678
	for <live-patching@vger.kernel.org>; Sat, 11 Nov 2023 03:20:41 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510152591;
	Fri, 10 Nov 2023 19:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699672840; x=1731208840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ARkRUyOLAIpmhjp2siRoxLvSfsSs3MBz/hMYy9pew/w=;
  b=AOPVxStzq3WLv8dklIznsqvANgMNRoeoe/egCa3ClRsLuMEVgLMQs/Jj
   e+4T7c3uEDQK4cF1aXzK7gRUVHruqks0BVQFCXCvHXf3kDOdxAkcS/sx5
   5J1FL/6jau0pHgcZoYdKLpDiAOSnMtEDBLDZS9V6ECGKKPhczDYUUYCLU
   4jMiIG8md9RTD8b/H0EeqTVOwhWwVEyfOFtEHWzjOkf9jLSgFM6DsvvnE
   Lrnr1eGLjkFaGzfLr/X/5lTPG7NsFfi+i3C2enwcFoHWyGghM8tRseg2Y
   lFxdZSqVP2jDWxs3LMu77kl3tCwPyLwW1VLvgF3KARmSudjKWSV1JZvzW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="375286638"
X-IronPort-AV: E=Sophos;i="6.03,294,1694761200"; 
   d="scan'208";a="375286638"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 19:20:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="792980847"
X-IronPort-AV: E=Sophos;i="6.03,294,1694761200"; 
   d="scan'208";a="792980847"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 10 Nov 2023 19:20:37 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r1eXy-000AAc-2V;
	Sat, 11 Nov 2023 03:20:34 +0000
Date: Sat, 11 Nov 2023 11:19:59 +0800
From: kernel test robot <lkp@intel.com>
To: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: Re: [POC 1/7] livepatch: Add callbacks for introducing and removing
 states
Message-ID: <202311111107.avVIpRi2-lkp@intel.com>
References: <20231110170428.6664-2-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110170428.6664-2-pmladek@suse.com>

Hi Petr,

kernel test robot noticed the following build warnings:

[auto build test WARNING on shuah-kselftest/next]
[also build test WARNING on shuah-kselftest/fixes linus/master v6.6 next-20231110]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Petr-Mladek/livepatch-Add-callbacks-for-introducing-and-removing-states/20231111-014906
base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
patch link:    https://lore.kernel.org/r/20231110170428.6664-2-pmladek%40suse.com
patch subject: [POC 1/7] livepatch: Add callbacks for introducing and removing states
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231111/202311111107.avVIpRi2-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231111/202311111107.avVIpRi2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311111107.avVIpRi2-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/livepatch/state.c:121:6: warning: no previous prototype for function 'is_state_in_other_patches' [-Wmissing-prototypes]
   bool is_state_in_other_patches(struct klp_patch *patch, struct klp_state *state)
        ^
   kernel/livepatch/state.c:121:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   bool is_state_in_other_patches(struct klp_patch *patch, struct klp_state *state)
   ^
   static 
   1 warning generated.


vim +/is_state_in_other_patches +121 kernel/livepatch/state.c

   120	
 > 121	bool is_state_in_other_patches(struct klp_patch *patch, struct klp_state *state)
   122	{
   123		struct klp_patch *old_patch;
   124		struct klp_state *old_state;
   125	
   126		klp_for_each_patch(old_patch) {
   127			if (old_patch == patch)
   128				continue;
   129	
   130			klp_for_each_state(old_patch, old_state) {
   131				if (old_state->id == state->id)
   132					return true;
   133			}
   134		}
   135	
   136		return false;
   137	}
   138	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

