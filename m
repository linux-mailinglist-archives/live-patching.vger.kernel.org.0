Return-Path: <live-patching+bounces-41-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1923B7E8769
	for <lists+live-patching@lfdr.de>; Sat, 11 Nov 2023 02:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94C45B20ACA
	for <lists+live-patching@lfdr.de>; Sat, 11 Nov 2023 01:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9851FB3;
	Sat, 11 Nov 2023 01:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I6dS6NBU"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258A01FC8
	for <live-patching@vger.kernel.org>; Sat, 11 Nov 2023 01:16:59 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61963422D;
	Fri, 10 Nov 2023 17:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699665418; x=1731201418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=00UAaZ78oicw/s6rxiSDFduERCEerluh526ys0B5b9M=;
  b=I6dS6NBUY+35ODA3mDdHMc2HPGpiGgBGZ7sGEkko/xF1TJiEdSHyRzqS
   LAt6FwLMq3OfLIf3ExGsZLWepVH4LZNtJn9KQqHdvcERL+KHGdDxdiQIf
   n1qFWFsv3sXNiS+wh+TCiTTIRU6V7WAHKcGiYcvvWAfiLDFXq2uRI0Sut
   xKokmsfudEVSzzeLGQ8pf1CaEzD+7uhsuF6p0+mpUuAVOWmfM0cRm65uO
   vxuQT77Oir/xwD5H8MEX7SXEytHGR/bdFPVAiXVlJkohjAvE24mSWS2W2
   j5QvYaJ60Of666HMXqhwoF35i7Px+WnP9U8JH+X/zhAFyaMggonMYWbwE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="370451462"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="370451462"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 17:16:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="887464269"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="887464269"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 10 Nov 2023 17:16:55 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r1ccH-000A7C-1z;
	Sat, 11 Nov 2023 01:16:53 +0000
Date: Sat, 11 Nov 2023 09:15:54 +0800
From: kernel test robot <lkp@intel.com>
To: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: oe-kbuild-all@lists.linux.dev, Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: Re: [POC 5/7] livepatch: Convert klp module callbacks tests into
 livepatch module tests
Message-ID: <202311110928.Ui5NizhT-lkp@intel.com>
References: <20231110170428.6664-6-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110170428.6664-6-pmladek@suse.com>

Hi Petr,

kernel test robot noticed the following build errors:

[auto build test ERROR on shuah-kselftest/next]
[also build test ERROR on shuah-kselftest/fixes linus/master v6.6 next-20231110]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Petr-Mladek/livepatch-Add-callbacks-for-introducing-and-removing-states/20231111-014906
base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
patch link:    https://lore.kernel.org/r/20231110170428.6664-6-pmladek%40suse.com
patch subject: [POC 5/7] livepatch: Convert klp module callbacks tests into livepatch module tests
config: s390-defconfig (https://download.01.org/0day-ci/archive/20231111/202311110928.Ui5NizhT-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231111/202311110928.Ui5NizhT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311110928.Ui5NizhT-lkp@intel.com/

All errors (new ones prefixed by >>):

>> make[5]: *** No rule to make target 'lib/livepatch/test_klp_speaker2.o', needed by 'lib/livepatch/'.
>> make[5]: *** No rule to make target 'lib/livepatch/test_klp_speaker_livepatch2.o', needed by 'lib/livepatch/'.
   make[5]: *** [scripts/Makefile.build:243: lib/livepatch/test_klp_speaker.o] Error 1
   make[5]: *** [scripts/Makefile.build:243: lib/livepatch/test_klp_speaker_livepatch.o] Error 1
   make[5]: Target 'lib/livepatch/' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

