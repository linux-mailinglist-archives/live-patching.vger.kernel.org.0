Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A5A51A2F4
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 17:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351722AbiEDPF7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 11:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351738AbiEDPFy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 11:05:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4391C125;
        Wed,  4 May 2022 08:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651676533; x=1683212533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IvFXkRXbvHPObyixE1YmNeS0d+XfUnkt8S7gVuXki5k=;
  b=AVpvhVXfARB44JLHtYUqyTI3Ba+GNbflUmhnQlTLb6Z5Vi/ehwZvmtEG
   vYU7qgh7dZY1oA31XpUj/ZHeUiYrRyUm68Ng3CWXfFEniW83Jooyk8F0m
   h+iaZFxTo7fOWwPrPjReAe269vESR67K2quQADox0hfW6E2ZfLXkp3d/E
   G1StITImQ92ry0A5hpl8UO2+jllCIk4IiOxdUx5U2/6llIIe9rGIRWJSn
   0JMJnDuKTOTcX5Qdq4daWCuCqX2WdZ2VXmMpV2b063YqPw92FsI4dt3GE
   3DFIyU5n2UN6KdirK9HmqYRMWXdB/tfX7mN5dksF4dzyRDrLe/fIlZQ3V
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="266633377"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="266633377"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 08:02:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="568139943"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 04 May 2022 08:02:06 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmGVx-000BSn-K8;
        Wed, 04 May 2022 15:02:05 +0000
Date:   Wed, 4 May 2022 23:01:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Seth Forshee <sforshee@digitalocean.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
Message-ID: <202205042204.CiMJBtiY-lkp@intel.com>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503174934.2641605-1-sforshee@digitalocean.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Seth,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on v5.18-rc5]
[also build test ERROR on next-20220504]
[cannot apply to tip/core/entry]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Seth-Forshee/entry-kvm-Make-vCPU-tasks-exit-to-userspace-when-a-livepatch-is-pending/20220504-015159
base:    672c0c5173427e6b3e2a9bbb7be51ceeec78093a
config: arm64-randconfig-r003-20220501 (https://download.01.org/0day-ci/archive/20220504/202205042204.CiMJBtiY-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 363b3a645a1e30011cc8da624f13dac5fd915628)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/1c97c02f02b9f8e6b8e1f11657f950510f9c828e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Seth-Forshee/entry-kvm-Make-vCPU-tasks-exit-to-userspace-when-a-livepatch-is-pending/20220504-015159
        git checkout 1c97c02f02b9f8e6b8e1f11657f950510f9c828e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kvm/arm.c:9:
>> include/linux/entry-kvm.h:80:22: error: use of undeclared identifier '_TIF_PATCH_PENDING'
           return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
                               ^
   include/linux/entry-kvm.h:20:41: note: expanded from macro 'XFER_TO_GUEST_MODE_WORK'
           (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
                                                  ^
   In file included from arch/arm64/kvm/arm.c:17:
   include/linux/mman.h:158:9: warning: division by zero is undefined [-Wdivision-by-zero]
                  _calc_vm_trans(flags, MAP_SYNC,       VM_SYNC      ) |
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mman.h:136:21: note: expanded from macro '_calc_vm_trans'
      : ((x) & (bit1)) / ((bit1) / (bit2))))
                       ^ ~~~~~~~~~~~~~~~~~
   1 warning and 1 error generated.
--
   In file included from kernel/entry/kvm.c:3:
>> include/linux/entry-kvm.h:80:22: error: use of undeclared identifier '_TIF_PATCH_PENDING'
           return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
                               ^
   include/linux/entry-kvm.h:20:41: note: expanded from macro 'XFER_TO_GUEST_MODE_WORK'
           (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
                                                  ^
>> kernel/entry/kvm.c:22:36: error: use of undeclared identifier '_TIF_PATCH_PENDING'
                   if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
                                                    ^
   kernel/entry/kvm.c:38:21: error: use of undeclared identifier '_TIF_PATCH_PENDING'
           } while (ti_work & XFER_TO_GUEST_MODE_WORK || need_resched());
                              ^
   include/linux/entry-kvm.h:20:41: note: expanded from macro 'XFER_TO_GUEST_MODE_WORK'
           (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
                                                  ^
   kernel/entry/kvm.c:55:18: error: use of undeclared identifier '_TIF_PATCH_PENDING'
           if (!(ti_work & XFER_TO_GUEST_MODE_WORK))
                           ^
   include/linux/entry-kvm.h:20:41: note: expanded from macro 'XFER_TO_GUEST_MODE_WORK'
           (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
                                                  ^
   4 errors generated.


vim +/_TIF_PATCH_PENDING +80 include/linux/entry-kvm.h

4ae7dc97f726ea Frederic Weisbecker 2021-02-01  67  
935ace2fb5cc49 Thomas Gleixner     2020-07-22  68  /**
935ace2fb5cc49 Thomas Gleixner     2020-07-22  69   * __xfer_to_guest_mode_work_pending - Check if work is pending
935ace2fb5cc49 Thomas Gleixner     2020-07-22  70   *
935ace2fb5cc49 Thomas Gleixner     2020-07-22  71   * Returns: True if work pending, False otherwise.
935ace2fb5cc49 Thomas Gleixner     2020-07-22  72   *
935ace2fb5cc49 Thomas Gleixner     2020-07-22  73   * Bare variant of xfer_to_guest_mode_work_pending(). Can be called from
935ace2fb5cc49 Thomas Gleixner     2020-07-22  74   * interrupt enabled code for racy quick checks with care.
935ace2fb5cc49 Thomas Gleixner     2020-07-22  75   */
935ace2fb5cc49 Thomas Gleixner     2020-07-22  76  static inline bool __xfer_to_guest_mode_work_pending(void)
935ace2fb5cc49 Thomas Gleixner     2020-07-22  77  {
6ce895128b3bff Mark Rutland        2021-11-29  78  	unsigned long ti_work = read_thread_flags();
935ace2fb5cc49 Thomas Gleixner     2020-07-22  79  
935ace2fb5cc49 Thomas Gleixner     2020-07-22 @80  	return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
935ace2fb5cc49 Thomas Gleixner     2020-07-22  81  }
935ace2fb5cc49 Thomas Gleixner     2020-07-22  82  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
