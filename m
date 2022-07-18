Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544E85779B5
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 05:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiGRDRb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 17 Jul 2022 23:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRDRa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 17 Jul 2022 23:17:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2D9E0DF;
        Sun, 17 Jul 2022 20:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658114249; x=1689650249;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wHnlpTyopzPYx4i3Zg8EzixyCbO3HkFrf2vWUj6FbC8=;
  b=Kqr6RqYbrHAVykAig/irXNv+KvDtZMCZzfydO4GvY0fdm4+E+XqcbBQe
   3Ryw05RDkBRHLS6SGgKcLl+htc1O7ue2PQIM/TVVO3YKeO0VNnkivVO/L
   gLm0uNZWweWGI41TgpN8rks3oivNyE4NB3J3+sEnVVjzfkJe88NT2MngS
   IbO8egl1NAaAT/Td2XafczeQCYfEm7F9gaKdi9g3FBBzzGgUz308ZoPeF
   EY9MOWqMlWU3D7c31xbKmRiBPFXMBK+kJbMGLvKvVj0lW4+aI5ynL8M70
   ZC9TpJLqrqml9Oe0drxtqoF+ztj2CZdLMhMcA7fdJl6L2UnzD+JkpjXmX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="286858663"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="286858663"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2022 20:17:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="547317801"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 17 Jul 2022 20:17:11 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDHFv-0003yU-78;
        Mon, 18 Jul 2022 03:17:11 +0000
Date:   Mon, 18 Jul 2022 11:16:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        daniel@iogearbox.net, kernel-team@fb.com, jolsa@kernel.org,
        rostedt@goodmis.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH v3 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Message-ID: <202207181116.PO2cQ09B-lkp@intel.com>
References: <20220718001405.2236811-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718001405.2236811-3-song@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
config: powerpc-randconfig-r023-20220717 (https://download.01.org/0day-ci/archive/20220718/202207181116.PO2cQ09B-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d74b88c69dc2644bd0dc5d64e2d7413a0d4040e5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/1535f287d288f9b7540ec50f56da1fe437ac6512
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-081533
        git checkout 1535f287d288f9b7540ec50f56da1fe437ac6512
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash kernel/trace/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/trace/ftrace.c:299:5: warning: no previous prototype for function '__register_ftrace_function' [-Wmissing-prototypes]
   int __register_ftrace_function(struct ftrace_ops *ops)
       ^
   kernel/trace/ftrace.c:299:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __register_ftrace_function(struct ftrace_ops *ops)
   ^
   static 
   kernel/trace/ftrace.c:342:5: warning: no previous prototype for function '__unregister_ftrace_function' [-Wmissing-prototypes]
   int __unregister_ftrace_function(struct ftrace_ops *ops)
       ^
   kernel/trace/ftrace.c:342:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __unregister_ftrace_function(struct ftrace_ops *ops)
   ^
   static 
   kernel/trace/ftrace.c:4030:15: warning: no previous prototype for function 'arch_ftrace_match_adjust' [-Wmissing-prototypes]
   char * __weak arch_ftrace_match_adjust(char *str, const char *search)
                 ^
   kernel/trace/ftrace.c:4030:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   char * __weak arch_ftrace_match_adjust(char *str, const char *search)
   ^
   static 
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
   kernel/trace/ftrace.c:8203:16: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
           mutex_unlock(&direct_mutex);
                         ^~~~~~~~~~~~
                         event_mutex
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
   3 warnings and 5 errors generated.


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
  8084		hash = ops->func_hash->filter_hash;
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
  8095					if (ops_references_ip(op, ip)) {
  8096						found_op = true;
  8097						break;
  8098					}
  8099				} while_for_each_ftrace_op(op);
  8100				mutex_unlock(&ftrace_lock);
  8101	
  8102				if (found_op) {
  8103					if (!op->ops_func) {
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
