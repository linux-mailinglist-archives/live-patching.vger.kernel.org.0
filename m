Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B125779C7
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 05:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiGRDg4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 17 Jul 2022 23:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGRDg4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 17 Jul 2022 23:36:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E60110FFA;
        Sun, 17 Jul 2022 20:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658115415; x=1689651415;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m1r/r+0xRg9No5beleifrlZuX+448SSJDDmD8d9ii7Y=;
  b=lO25lR9n6Na0YxEjcASYNXKtZcuNMKBVDN5sM26zHEtgTyEb4zZ+IqdI
   Q8esVXhkQWdU9IpwcUR2vkeRX9crWTzFAlLZHB17k/j2wSex4Rcun58G/
   WeXriEdx723o6nixDrpgXOawaC5o+SkvFj6IO14vAa94jxt7Xn0L/xL97
   TEXAMApQ70aD/CNloNhVrHu1uIyb9cSwgr06Nvaf9MMUoT2Dooy0UMpnX
   BwFmlFByWY8l0yEcT3UvdQmDzFizr5FBokdXSw6ESQ1JouaZiSVSzf9dR
   vyJ08Oi09dkrSDhJJLh9DfufIV9lZ2BxP0noYlQ9YPUr7HPYqi3n6eAoQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="286143897"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="286143897"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2022 20:36:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="686590718"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jul 2022 20:36:51 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDHYw-0003ys-Tm;
        Mon, 18 Jul 2022 03:36:50 +0000
Date:   Mon, 18 Jul 2022 11:36:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        daniel@iogearbox.net, kernel-team@fb.com, jolsa@kernel.org,
        rostedt@goodmis.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH v3 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Message-ID: <202207181140.tqIgD0Jp-lkp@intel.com>
References: <20220718001405.2236811-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718001405.2236811-3-song@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Song,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-081533
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-randconfig-a001 (https://download.01.org/0day-ci/archive/20220718/202207181140.tqIgD0Jp-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d74b88c69dc2644bd0dc5d64e2d7413a0d4040e5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1535f287d288f9b7540ec50f56da1fe437ac6512
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-081533
        git checkout 1535f287d288f9b7540ec50f56da1fe437ac6512
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> kernel/trace/ftrace.c:8082:14: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
           mutex_lock(&direct_mutex);
                       ^~~~~~~~~~~~
                       event_mutex
   include/linux/mutex.h:187:44: note: expanded from macro 'mutex_lock'
   #define mutex_lock(lock) mutex_lock_nested(lock, 0)
                                              ^
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
>> kernel/trace/ftrace.c:8084:14: error: no member named 'func_hash' in 'struct ftrace_ops'
           hash = ops->func_hash->filter_hash;
                  ~~~  ^
>> kernel/trace/ftrace.c:8095:9: error: call to undeclared function 'ops_references_ip'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                                   if (ops_references_ip(op, ip)) {
                                       ^
>> kernel/trace/ftrace.c:8103:14: error: no member named 'ops_func' in 'struct ftrace_ops'
                                   if (!op->ops_func) {
                                        ~~  ^
   kernel/trace/ftrace.c:8107:15: error: no member named 'ops_func' in 'struct ftrace_ops'
                                   ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER);
                                         ~~  ^
   kernel/trace/ftrace.c:8122:16: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
           mutex_unlock(&direct_mutex);
                         ^~~~~~~~~~~~
                         event_mutex
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
   kernel/trace/ftrace.c:8158:17: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
                   mutex_unlock(&direct_mutex);
                                 ^~~~~~~~~~~~
                                 event_mutex
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
   kernel/trace/ftrace.c:8178:14: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
           mutex_lock(&direct_mutex);
                       ^~~~~~~~~~~~
                       event_mutex
   include/linux/mutex.h:187:44: note: expanded from macro 'mutex_lock'
   #define mutex_lock(lock) mutex_lock_nested(lock, 0)
                                              ^
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
   kernel/trace/ftrace.c:8180:14: error: no member named 'func_hash' in 'struct ftrace_ops'
           hash = ops->func_hash->filter_hash;
                  ~~~  ^
   kernel/trace/ftrace.c:8191:9: error: call to undeclared function 'ops_references_ip'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                                   if (ops_references_ip(op, ip)) {
                                       ^
   kernel/trace/ftrace.c:8199:24: error: no member named 'ops_func' in 'struct ftrace_ops'
                           if (found_op && op->ops_func)
                                           ~~  ^
   kernel/trace/ftrace.c:8200:9: error: no member named 'ops_func' in 'struct ftrace_ops'
                                   op->ops_func(op, FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER);
                                   ~~  ^
   kernel/trace/ftrace.c:8203:16: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
           mutex_unlock(&direct_mutex);
                         ^~~~~~~~~~~~
                         event_mutex
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
   13 errors generated.


vim +8082 kernel/trace/ftrace.c

  8051	
  8052	/*
  8053	 * When registering ftrace_ops with IPMODIFY, it is necessary to make sure
  8054	 * it doesn't conflict with any direct ftrace_ops. If there is existing
  8055	 * direct ftrace_ops on a kernel function being patched, call
  8056	 * FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER on it to enable sharing.
  8057	 *
  8058	 * @ops:     ftrace_ops being registered.
  8059	 *
  8060	 * Returns:
  8061	 *         0 - @ops does not have IPMODIFY or @ops itself is DIRECT, no
  8062	 *             change needed;
  8063	 *         1 - @ops has IPMODIFY, hold direct_mutex;
  8064	 *         -EBUSY - currently registered DIRECT ftrace_ops cannot share the
  8065	 *                  same function with IPMODIFY, abort the register.
  8066	 *         -EAGAIN - cannot make changes to currently registered DIRECT
  8067	 *                   ftrace_ops due to rare race conditions. Should retry
  8068	 *                   later. This is needed to avoid potential deadlocks
  8069	 *                   on the DIRECT ftrace_ops side.
  8070	 */
  8071	static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
  8072		__acquires(&direct_mutex)
  8073	{
  8074		struct ftrace_func_entry *entry;
  8075		struct ftrace_hash *hash;
  8076		struct ftrace_ops *op;
  8077		int size, i, ret;
  8078	
  8079		if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
  8080			return 0;
  8081	
> 8082		mutex_lock(&direct_mutex);
  8083	
> 8084		hash = ops->func_hash->filter_hash;
  8085		size = 1 << hash->size_bits;
  8086		for (i = 0; i < size; i++) {
  8087			hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
  8088				unsigned long ip = entry->ip;
  8089				bool found_op = false;
  8090	
  8091				mutex_lock(&ftrace_lock);
  8092				do_for_each_ftrace_op(op, ftrace_ops_list) {
  8093					if (!(op->flags & FTRACE_OPS_FL_DIRECT))
  8094						continue;
> 8095					if (ops_references_ip(op, ip)) {
  8096						found_op = true;
  8097						break;
  8098					}
  8099				} while_for_each_ftrace_op(op);
  8100				mutex_unlock(&ftrace_lock);
  8101	
  8102				if (found_op) {
> 8103					if (!op->ops_func) {
  8104						ret = -EBUSY;
  8105						goto err_out;
  8106					}
  8107					ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER);
  8108					if (ret)
  8109						goto err_out;
  8110				}
  8111			}
  8112		}
  8113	
  8114		/*
  8115		 * Didn't find any overlap with direct ftrace_ops, or the direct
  8116		 * function can share with ipmodify. Hold direct_mutex to make sure
  8117		 * this doesn't change until we are done.
  8118		 */
  8119		return 1;
  8120	
  8121	err_out:
  8122		mutex_unlock(&direct_mutex);
  8123		return ret;
  8124	}
  8125	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
