Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA77577CBB
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 09:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiGRHnE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 03:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiGRHnD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 03:43:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714FC17582;
        Mon, 18 Jul 2022 00:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658130182; x=1689666182;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RT/evMuTczhZaXG+1OMdRlzK81/SHsZdGYYmkKKKgOs=;
  b=jxSzZOPZ3k7J/wsjfW53sFigX1bVtepJYXke6ufAfXz4eXQ5snKWLo7/
   8y3MYHYtDi2SHgXd22ifwI9awGg7WpB2nYHspkQGA5SUgZjvRLQmeGQ+8
   lCAKNa6XKX/CruJos9E2FlHdmYHPIDtzMSawDmCTFPgv0CuM/PJ/Bxk7W
   fhYq3bWBNc8VPIgx+itnepN40ersIYEVh+sMUxfxKxqnUZFl9AZUjMxYU
   X9VIG0bd93+YSMF2vIYw3sknDjRaJBKy9SE9w2BbxweX7k9Vyjgi9RDSH
   k6RyY2S5iTnYm98A0B2+8E9lhSNM6hiN4PLOLu2bVDzwiqAAA0nO3laKD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="372466261"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="372466261"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 00:43:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="664914578"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jul 2022 00:42:52 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDLP1-00049C-Ow;
        Mon, 18 Jul 2022 07:42:51 +0000
Date:   Mon, 18 Jul 2022 15:42:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc:     kbuild-all@lists.01.org, daniel@iogearbox.net, kernel-team@fb.com,
        jolsa@kernel.org, rostedt@goodmis.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Message-ID: <202207181552.VuKfz9zg-lkp@intel.com>
References: <20220718055449.3960512-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718055449.3960512-3-song@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Song,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-135652
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-randconfig-a004 (https://download.01.org/0day-ci/archive/20220718/202207181552.VuKfz9zg-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/9ef1ec8cb818d8ca70887c8c123f2d579384a6c6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-135652
        git checkout 9ef1ec8cb818d8ca70887c8c123f2d579384a6c6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash kernel/trace/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/trace/ftrace.c: In function 'register_ftrace_function':
>> kernel/trace/ftrace.c:8197:14: warning: variable 'direct_mutex_locked' set but not used [-Wunused-but-set-variable]
    8197 |         bool direct_mutex_locked = false;
         |              ^~~~~~~~~~~~~~~~~~~


vim +/direct_mutex_locked +8197 kernel/trace/ftrace.c

  8182	
  8183	/**
  8184	 * register_ftrace_function - register a function for profiling
  8185	 * @ops:	ops structure that holds the function for profiling.
  8186	 *
  8187	 * Register a function to be called by all functions in the
  8188	 * kernel.
  8189	 *
  8190	 * Note: @ops->func and all the functions it calls must be labeled
  8191	 *       with "notrace", otherwise it will go into a
  8192	 *       recursive loop.
  8193	 */
  8194	int register_ftrace_function(struct ftrace_ops *ops)
  8195		__releases(&direct_mutex)
  8196	{
> 8197		bool direct_mutex_locked = false;
  8198		int ret;
  8199	
  8200		ftrace_ops_init(ops);
  8201	
  8202		ret = prepare_direct_functions_for_ipmodify(ops);
  8203		if (ret < 0)
  8204			return ret;
  8205		else if (ret == 1)
  8206			direct_mutex_locked = true;
  8207	
  8208		mutex_lock(&ftrace_lock);
  8209	
  8210		ret = ftrace_startup(ops, 0);
  8211	
  8212		mutex_unlock(&ftrace_lock);
  8213	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
