Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B8F5F83F1
	for <lists+live-patching@lfdr.de>; Sat,  8 Oct 2022 09:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJHHJS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 8 Oct 2022 03:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJHHJR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 8 Oct 2022 03:09:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28CCBC60E;
        Sat,  8 Oct 2022 00:09:13 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mkx4H3h6hzHtvW;
        Sat,  8 Oct 2022 15:04:15 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 15:09:11 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 15:09:10 +0800
Subject: Re: [PATCH v6 11/11] kallsyms: Add self-test facility
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
References: <20220924122051.362-12-thunder.leizhen@huawei.com>
 <202210060828.LgrzwmRo-lkp@intel.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <1f7e5ebd-8345-41cd-ba9e-c4cef28c5574@huawei.com>
Date:   Sat, 8 Oct 2022 15:09:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <202210060828.LgrzwmRo-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/10/6 8:24, kernel test robot wrote:
> Hi Zhen,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on mcgrof/modules-next]
> [also build test ERROR on rostedt-trace/for-next v6.0]
> [cannot apply to linus/master next-20221005]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20220924-202522
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git modules-next
> config: i386-allyesconfig
> compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/43e45bdbf95415fc26a9d55e7db43a75bdb8e99a
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20220924-202522
>         git checkout 43e45bdbf95415fc26a9d55e7db43a75bdb8e99a
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    ld: kernel/kallsyms_selftest.o: in function `test_perf_kallsyms_lookup_name':
>>> kallsyms_selftest.c:(.text.unlikely+0x5e3): undefined reference to `__udivdi3'
>    ld: kernel/kallsyms_selftest.o: in function `test_kallsyms_compression_ratio':
>    kallsyms_selftest.c:(.text.unlikely+0x771): undefined reference to `__udivdi3'
> 

OK, thanks, I should use do_div() to calculate percentage.


-- 
Regards,
  Zhen Lei
