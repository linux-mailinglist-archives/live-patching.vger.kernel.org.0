Return-Path: <live-patching+bounces-40-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0982E7E8701
	for <lists+live-patching@lfdr.de>; Sat, 11 Nov 2023 01:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F4D11F20EFF
	for <lists+live-patching@lfdr.de>; Sat, 11 Nov 2023 00:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938FA386;
	Sat, 11 Nov 2023 00:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nCnF+om0"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B093137B
	for <live-patching@vger.kernel.org>; Sat, 11 Nov 2023 00:54:56 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE334228;
	Fri, 10 Nov 2023 16:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699664096; x=1731200096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4uIZuu0TuTDz28DR353gxEbj7Ysav5dxrUtDYZQ8g+U=;
  b=nCnF+om0MoUKB9uV4TnZBfKNrbKuyALPK3TreoVSxA6M5On4xojHriOP
   6KFo7A+nc+AxH5VWvyGYkf28fmOghQWug+9T1/Q/reCBb53dvk3paE+Jd
   qe2M5tvfi7iLB4aGC1TpYMh3h/jTExPZHaMVk5FRcBazImePvDeHDFeYb
   x/lIRQevg/hztAL/t6laRyNk+fn4M5etOLyAI9vFtATqShPPckKZyzlQN
   QPHv6Ll6mqJ+//lc9DNcS82v9sRwVps/UNaCaUMfu/mTqgfnYpzYOitPQ
   8a3Q4KDeJ+H/dImwkyL2fVuo6946ytRb86YrGPH/N2NATLLmHCmUSWPds
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="11798467"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="11798467"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 16:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="767442281"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="767442281"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 10 Nov 2023 16:54:53 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r1cGx-000A6D-29;
	Sat, 11 Nov 2023 00:54:51 +0000
Date: Sat, 11 Nov 2023 08:54:08 +0800
From: kernel test robot <lkp@intel.com>
To: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: oe-kbuild-all@lists.linux.dev, Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: Re: [POC 1/7] livepatch: Add callbacks for introducing and removing
 states
Message-ID: <202311110829.UKC9GiUG-lkp@intel.com>
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
config: x86_64-randconfig-006-20231111 (https://download.01.org/0day-ci/archive/20231111/202311110829.UKC9GiUG-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231111/202311110829.UKC9GiUG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311110829.UKC9GiUG-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/livepatch/state.c:121:6: warning: no previous prototype for 'is_state_in_other_patches' [-Wmissing-prototypes]
     121 | bool is_state_in_other_patches(struct klp_patch *patch, struct klp_state *state)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~


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

