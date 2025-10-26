Return-Path: <live-patching+bounces-1811-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74638C0A5A9
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 10:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D7DD18A052F
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 09:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58803220F37;
	Sun, 26 Oct 2025 09:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VF11bhJ/"
X-Original-To: live-patching@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C181DD525;
	Sun, 26 Oct 2025 09:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761472447; cv=none; b=fctaZ/I5uivm29H10xqxcHp2kIH4avMB/Hjbxm1xd1oiqWgVnppmX8WLLEAEh1q6JELR4yndAO89YOHffcZHvjCMeUP5C8i8dIDv9s26voH3B2uVEi/GHZmbwua3Dil3uiy2mspiyYI7GRwusAV2Aode3iAUKfikh4f1d1sI1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761472447; c=relaxed/simple;
	bh=yrhzUdN3+Umrl/X0VPnOijPThmoLqx2wbg2hahY7pjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvNEU9mnnpyGK1d3Wwy3fRjSbV5s2YmeWv8fc26U5ASOhYpLazgzHJ2zyW6IpRyV7St9LzPMt7xX13afHixVpXh/byrSFmHh2IMvwW0iIxHx5ek2ixhr2tmy1HcTFazhXrelF+nhedgV8R9chUY+/RljHCS2srBLAOBO8caBjNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VF11bhJ/; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761472446; x=1793008446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yrhzUdN3+Umrl/X0VPnOijPThmoLqx2wbg2hahY7pjY=;
  b=VF11bhJ/eeXnHXIJQZLPftQIJbP+WLbm7qWmgN41Z8JFw8nh0OhQ0yvr
   Gs1P2dou3+8SyeQBsYynS0wwcbrNNZMQsRSChjV7/BY5/wUGWxbomRxc0
   iBZKKmva8gpx0qbuC92oS9sXlZ6VN5o41c5AE9qflN3kq3UjptrU19361
   6mT/y/otbh4FFopMlGH9QcskanJY6zaWkWMM+Mu4xhImlw9zyy5Ukx37W
   fK0ueM30sf0u4YmTx+uKRvcmjo93jgs2c2zwnFrgyTMmbIoSEKDAOFNg9
   0b2HcalwTAPfJFVMUtqDqEmgqqycbmgkeUN3OvGl/X4Ra8eBKBrY2DuHw
   A==;
X-CSE-ConnectionGUID: pDeduQ3hTKSuWBoCCQCy/g==
X-CSE-MsgGUID: qoaAZW2+SYi2qJPntmJ2VQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81009153"
X-IronPort-AV: E=Sophos;i="6.19,256,1754982000"; 
   d="scan'208";a="81009153"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 02:54:04 -0700
X-CSE-ConnectionGUID: IfIOOh9GTxyTYqnNPYVvcQ==
X-CSE-MsgGUID: IhlL59izRci7VIHXUGHL+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,256,1754982000"; 
   d="scan'208";a="183982311"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 26 Oct 2025 02:54:01 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vCxRm-000G2D-1S;
	Sun, 26 Oct 2025 09:53:58 +0000
Date: Sun, 26 Oct 2025 17:53:43 +0800
From: kernel test robot <lkp@intel.com>
To: Song Liu <song@kernel.org>, bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, rostedt@goodmis.org,
	andrey.grodzovsky@crowdstrike.com, mhiramat@kernel.org,
	kernel-team@meta.com, olsajiri@gmail.com,
	Song Liu <song@kernel.org>
Subject: Re: [PATCH v2 bpf 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in
 modify_ftrace_direct()
Message-ID: <202510261733.fSN9P6td-lkp@intel.com>
References: <20251024182901.3247573-3-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024182901.3247573-3-song@kernel.org>

Hi Song,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-Fix-BPF-fexit-with-livepatch/20251025-023411
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/20251024182901.3247573-3-song%40kernel.org
patch subject: [PATCH v2 bpf 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
config: sparc-randconfig-r132-20251026 (https://download.01.org/0day-ci/archive/20251026/202510261733.fSN9P6td-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251026/202510261733.fSN9P6td-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510261733.fSN9P6td-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/bpf/trampoline.c: In function 'register_fentry':
>> kernel/bpf/trampoline.c:229:11: error: dereferencing pointer to incomplete type 'struct ftrace_ops'
      tr->fops->trampoline = 0;
              ^~


vim +229 kernel/bpf/trampoline.c

   207	
   208	/* first time registering */
   209	static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
   210	{
   211		void *ip = tr->func.addr;
   212		unsigned long faddr;
   213		int ret;
   214	
   215		faddr = ftrace_location((unsigned long)ip);
   216		if (faddr) {
   217			if (!tr->fops)
   218				return -ENOTSUPP;
   219			tr->func.ftrace_managed = true;
   220		}
   221	
   222		if (tr->func.ftrace_managed) {
   223			ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
   224			/*
   225			 * Clearing fops->trampoline and fops->NULL is
   226			 * needed by the "goto again" case in
   227			 * bpf_trampoline_update().
   228			 */
 > 229			tr->fops->trampoline = 0;
   230			tr->fops->func = NULL;
   231			ret = register_ftrace_direct(tr->fops, (long)new_addr);
   232		} else {
   233			ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
   234		}
   235	
   236		return ret;
   237	}
   238	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

