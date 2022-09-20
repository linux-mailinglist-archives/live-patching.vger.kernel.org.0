Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB66A5BDCEE
	for <lists+live-patching@lfdr.de>; Tue, 20 Sep 2022 08:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiITGNi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Sep 2022 02:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiITGNe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Sep 2022 02:13:34 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710C243626;
        Mon, 19 Sep 2022 23:13:32 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MWrjK1gR6z14QkD;
        Tue, 20 Sep 2022 14:09:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 14:13:30 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 14:13:29 +0800
Subject: Re: [PATCH v3 8/8] kallsyms: Add self-test facility
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
        <linux-modules@vger.kernel.org>
CC:     <llvm@lists.linux.dev>, <kbuild-all@lists.01.org>,
        "Linux Memory Management List" <linux-mm@kvack.org>
References: <20220919151533.1734-9-thunder.leizhen@huawei.com>
 <202209201123.hihIfjo1-lkp@intel.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <6c02ff59-99f9-5a4b-9bf2-ab0ea12de2c8@huawei.com>
Date:   Tue, 20 Sep 2022 14:13:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <202209201123.hihIfjo1-lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/20 11:14, kernel test robot wrote:
> Hi Zhen,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on mcgrof/modules-next]
> [also build test WARNING on linus/master v6.0-rc6 next-20220919]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20220919-231916
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git modules-next
> config: i386-randconfig-a001-20220919 (https://download.01.org/0day-ci/archive/20220920/202209201123.hihIfjo1-lkp@intel.com/config)
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/26fdb8f3984ffbdb57da2d1fac7e32ae418bfa96
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20220919-231916
>         git checkout 26fdb8f3984ffbdb57da2d1fac7e32ae418bfa96
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> kernel/kallsyms.c:196:15: warning: no previous prototype for function 'kallsyms_sym_address' [-Wmissing-prototypes]
>    unsigned long kallsyms_sym_address(int idx)
>                  ^
>    kernel/kallsyms.c:196:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    unsigned long kallsyms_sym_address(int idx)
>    ^

Well, thanks. Because it's just for testing code, I'm thinking about not
changing the header file, but it looks like I'll have to change it.

>    static 
>    kernel/kallsyms.c:668:12: warning: no previous prototype for function 'arch_get_kallsym' [-Wmissing-prototypes]
>    int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
>               ^
>    kernel/kallsyms.c:668:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
>    ^
>    static 
>    2 warnings generated.
> 
> 
> vim +/kallsyms_sym_address +196 kernel/kallsyms.c
> 
>    195	
>  > 196	unsigned long kallsyms_sym_address(int idx)
>    197	{
>    198		if (!IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE))
>    199			return kallsyms_addresses[idx];
>    200	
>    201		/* values are unsigned offsets if --absolute-percpu is not in effect */
>    202		if (!IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU))
>    203			return kallsyms_relative_base + (u32)kallsyms_offsets[idx];
>    204	
>    205		/* ...otherwise, positive offsets are absolute values */
>    206		if (kallsyms_offsets[idx] >= 0)
>    207			return kallsyms_offsets[idx];
>    208	
>    209		/* ...and negative offsets are relative to kallsyms_relative_base - 1 */
>    210		return kallsyms_relative_base - 1 - kallsyms_offsets[idx];
>    211	}
>    212	
> 

-- 
Regards,
  Zhen Lei
