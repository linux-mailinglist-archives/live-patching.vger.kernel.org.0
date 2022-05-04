Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89029519335
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 03:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbiEDBOX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 May 2022 21:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245091AbiEDBNb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 May 2022 21:13:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA54B434BB;
        Tue,  3 May 2022 18:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651626577; x=1683162577;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Buwj+SlxXPnBGJavHI7353FU4QgOf6AThckH8kUbZjQ=;
  b=IHsq5odG1ME+4w29sz0dlTtk71Qit49zaAWNl48pMcbXnV22/KCqXXbZ
   BPr0M1w3UL8lrdDX8aTXHRkxAXVVGSR6xVV4pjx90N2U57RFsvFOLyAD/
   93cg/D7Te+fW1YbhzKPWvkbWNvFzHIp6H5qps0Tq9t38tNaTqCdY980Gk
   9EkP7LBXZBbByXpNxrIAetQXMk3j3zC1xVut+X45Q8vnEsbvV/WeEZ2Dm
   +EgQROlh8xnigyvkMxnjsHHBnH7oRN4a/bvZQVsFUuHp9pDq2uegWrv7I
   JHC6619+x0v4jwULzjn4jpAb9L0xPDk7oPl9jX20BumGlaN4MQcFOtFFC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="354071054"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="354071054"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 18:09:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="599317744"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 03 May 2022 18:09:32 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nm3WF-000AvV-VO;
        Wed, 04 May 2022 01:09:31 +0000
Date:   Wed, 4 May 2022 09:08:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Seth Forshee <sforshee@digitalocean.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     kbuild-all@lists.01.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
Message-ID: <202205040945.JZNNub2D-lkp@intel.com>
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
[also build test ERROR on next-20220503]
[cannot apply to tip/core/entry]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Seth-Forshee/entry-kvm-Make-vCPU-tasks-exit-to-userspace-when-a-livepatch-is-pending/20220504-015159
base:    672c0c5173427e6b3e2a9bbb7be51ceeec78093a
config: arm64-randconfig-r034-20220502 (https://download.01.org/0day-ci/archive/20220504/202205040945.JZNNub2D-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1c97c02f02b9f8e6b8e1f11657f950510f9c828e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Seth-Forshee/entry-kvm-Make-vCPU-tasks-exit-to-userspace-when-a-livepatch-is-pending/20220504-015159
        git checkout 1c97c02f02b9f8e6b8e1f11657f950510f9c828e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kvm/arm.c:9:
   include/linux/entry-kvm.h: In function '__xfer_to_guest_mode_work_pending':
>> include/linux/entry-kvm.h:20:48: error: '_TIF_PATCH_PENDING' undeclared (first use in this function)
      20 |         (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
         |                                                ^~~~~~~~~~~~~~~~~~
   include/linux/entry-kvm.h:80:29: note: in expansion of macro 'XFER_TO_GUEST_MODE_WORK'
      80 |         return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
         |                             ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/entry-kvm.h:20:48: note: each undeclared identifier is reported only once for each function it appears in
      20 |         (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
         |                                                ^~~~~~~~~~~~~~~~~~
   include/linux/entry-kvm.h:80:29: note: in expansion of macro 'XFER_TO_GUEST_MODE_WORK'
      80 |         return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
         |                             ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/entry-kvm.h:81:1: error: control reaches end of non-void function [-Werror=return-type]
      81 | }
         | ^
   cc1: some warnings being treated as errors
--
   In file included from kernel/entry/kvm.c:3:
   include/linux/entry-kvm.h: In function '__xfer_to_guest_mode_work_pending':
>> include/linux/entry-kvm.h:20:48: error: '_TIF_PATCH_PENDING' undeclared (first use in this function)
      20 |         (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
         |                                                ^~~~~~~~~~~~~~~~~~
   include/linux/entry-kvm.h:80:29: note: in expansion of macro 'XFER_TO_GUEST_MODE_WORK'
      80 |         return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
         |                             ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/entry-kvm.h:20:48: note: each undeclared identifier is reported only once for each function it appears in
      20 |         (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
         |                                                ^~~~~~~~~~~~~~~~~~
   include/linux/entry-kvm.h:80:29: note: in expansion of macro 'XFER_TO_GUEST_MODE_WORK'
      80 |         return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
         |                             ^~~~~~~~~~~~~~~~~~~~~~~
   kernel/entry/kvm.c: In function 'xfer_to_guest_mode_work':
>> kernel/entry/kvm.c:22:50: error: '_TIF_PATCH_PENDING' undeclared (first use in this function)
      22 |                 if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
         |                                                  ^~~~~~~~~~~~~~~~~~
   In file included from kernel/entry/kvm.c:3:
   kernel/entry/kvm.c: In function 'xfer_to_guest_mode_handle_work':
>> include/linux/entry-kvm.h:20:48: error: '_TIF_PATCH_PENDING' undeclared (first use in this function)
      20 |         (_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |     \
         |                                                ^~~~~~~~~~~~~~~~~~
   kernel/entry/kvm.c:55:25: note: in expansion of macro 'XFER_TO_GUEST_MODE_WORK'
      55 |         if (!(ti_work & XFER_TO_GUEST_MODE_WORK))
         |                         ^~~~~~~~~~~~~~~~~~~~~~~


vim +/_TIF_PATCH_PENDING +20 include/linux/entry-kvm.h

    18	
    19	#define XFER_TO_GUEST_MODE_WORK						\
  > 20		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
    21		 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
    22	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
