Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956D6603C00
	for <lists+live-patching@lfdr.de>; Wed, 19 Oct 2022 10:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiJSImW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Oct 2022 04:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiJSIlm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Oct 2022 04:41:42 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D8281125;
        Wed, 19 Oct 2022 01:39:16 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MskYL38pyz1P7BJ;
        Wed, 19 Oct 2022 16:34:30 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 16:39:13 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 16:39:12 +0800
Subject: Re: [PATCH v7 11/11] kallsyms: Add self-test facility
To:     kernel test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>
CC:     <kbuild-all@lists.01.org>,
        Linux Memory Management List <linux-mm@kvack.org>
References: <20221017064950.2038-12-thunder.leizhen@huawei.com>
 <202210181740.PAAHM5dR-lkp@intel.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <9cc2b731-0de8-6c43-5ea0-a2465d0f1c31@huawei.com>
Date:   Wed, 19 Oct 2022 16:39:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <202210181740.PAAHM5dR-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/10/18 17:32, kernel test robot wrote:
> Hi Zhen,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on masahiroy-kbuild/for-next]
> [also build test ERROR on linus/master v6.1-rc1 next-20221018]
> [cannot apply to mcgrof/modules-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20221017-145455
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git for-next
> patch link:    https://lore.kernel.org/r/20221017064950.2038-12-thunder.leizhen%40huawei.com
> patch subject: [PATCH v7 11/11] kallsyms: Add self-test facility
> config: mips-allyesconfig
> compiler: mips-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/3f5fc7fa1f657df865ef14b2d24f837a7cc079c9
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20221017-145455
>         git checkout 3f5fc7fa1f657df865ef14b2d24f837a7cc079c9
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>>
> All errors (new ones prefixed by >>):
> 
>    arch/mips/kernel/head.o: in function `kernel_entry':
>    (.ref.text+0xac): relocation truncated to fit: R_MIPS_26 against `start_kernel'
>    init/main.o: in function `set_reset_devices':
>    main.c:(.init.text+0x20): relocation truncated to fit: R_MIPS_26 against `_mcount'
>    main.c:(.init.text+0x30): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
>    init/main.o: in function `debug_kernel':
>    main.c:(.init.text+0xa4): relocation truncated to fit: R_MIPS_26 against `_mcount'
>    main.c:(.init.text+0xb4): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
>    init/main.o: in function `quiet_kernel':
>    main.c:(.init.text+0x128): relocation truncated to fit: R_MIPS_26 against `_mcount'
>    main.c:(.init.text+0x138): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
>    init/main.o: in function `warn_bootconfig':
>    main.c:(.init.text+0x1ac): relocation truncated to fit: R_MIPS_26 against `_mcount'
>    main.c:(.init.text+0x1bc): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
>    init/main.o: in function `init_setup':
>    main.c:(.init.text+0x234): relocation truncated to fit: R_MIPS_26 against `_mcount'
>    main.c:(.init.text+0x254): additional relocation overflows omitted from the output
>    mips-linux-ld: kernel/kallsyms_selftest.o: in function `test_perf_kallsyms_lookup_name':
>>> kallsyms_selftest.c:(.text.unlikely.test_perf_kallsyms_lookup_name+0x100): undefined reference to `__udivdi3'

OK, thanks. I will fix it in the next version.

> 

-- 
Regards,
  Zhen Lei
