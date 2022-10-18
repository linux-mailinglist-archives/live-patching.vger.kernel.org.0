Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1121A602803
	for <lists+live-patching@lfdr.de>; Tue, 18 Oct 2022 11:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiJRJLa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 18 Oct 2022 05:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJRJL1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 18 Oct 2022 05:11:27 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65C115FD9;
        Tue, 18 Oct 2022 02:11:24 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Ms7MJ52JfzJn2y;
        Tue, 18 Oct 2022 17:08:44 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 17:11:18 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 17:11:17 +0800
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
 <202210181636.S8XlpSMd-lkp@intel.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <e8c45c81-d488-db80-57cf-cfc59f05f32d@huawei.com>
Date:   Tue, 18 Oct 2022 17:11:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <202210181636.S8XlpSMd-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/10/18 16:21, kernel test robot wrote:
> Hi Zhen,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on masahiroy-kbuild/for-next]
> [also build test WARNING on linus/master v6.1-rc1 next-20221018]
> [cannot apply to mcgrof/modules-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20221017-145455
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git for-next
> patch link:    https://lore.kernel.org/r/20221017064950.2038-12-thunder.leizhen%40huawei.com
> patch subject: [PATCH v7 11/11] kallsyms: Add self-test facility
> config: sh-allmodconfig
> compiler: sh4-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/3f5fc7fa1f657df865ef14b2d24f837a7cc079c9
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20221017-145455
>         git checkout 3f5fc7fa1f657df865ef14b2d24f837a7cc079c9
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    kernel/kallsyms_selftest.c:67:5: warning: no previous prototype for 'test_func' [-Wmissing-prototypes]
>       67 | int test_func(void)
>          |     ^~~~~~~~~
>    kernel/kallsyms_selftest.c:72:12: warning: no previous prototype for 'test_func_weak' [-Wmissing-prototypes]
>       72 | __weak int test_func_weak(void)
>          |            ^~~~~~~~~~~~~~
>    kernel/kallsyms_selftest.c: In function 'test_kallsyms_basic_function':
>>> kernel/kallsyms_selftest.c:424:1: warning: the frame size of 1124 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>      424 | }
>          | ^

OK, thanks. These warnings are minor. I will fix them in the next version after collecting review comments.

> 
> 
> vim +424 kernel/kallsyms_selftest.c
> 
>    275	
>    276	static int test_kallsyms_basic_function(void)
>    277	{
>    278		int i, j, ret;
>    279		int next = 0, nr_failed = 0;
>    280		char *prefix;
>    281		unsigned short rand;
>    282		unsigned long addr, lookup_addr;
>    283		char namebuf[KSYM_NAME_LEN];
>    284		struct test_stat stat, stat2;
>    285	
>    286		prefix = "kallsyms_lookup_name() for";
>    287		for (i = 0; i < ARRAY_SIZE(test_items); i++) {
>    288			addr = kallsyms_lookup_name(test_items[i].name);
>    289			if (addr != test_items[i].addr) {
>    290				nr_failed++;
>    291				pr_info("%s %s failed: addr=%lx, expect %lx\n",
>    292					prefix, test_items[i].name, addr, test_items[i].addr);
>    293			}
>    294		}
>    295	
>    296		prefix = "kallsyms_on_each_symbol() for";
>    297		for (i = 0; i < ARRAY_SIZE(test_items); i++) {
>    298			memset(&stat, 0, sizeof(stat));
>    299			stat.max = INT_MAX;
>    300			stat.name = test_items[i].name;
>    301			kallsyms_on_each_symbol(find_symbol, &stat);
>    302			if (stat.addr != test_items[i].addr || stat.real_cnt != 1) {
>    303				nr_failed++;
>    304				pr_info("%s %s failed: count=%d, addr=%lx, expect %lx\n",
>    305					prefix, test_items[i].name,
>    306					stat.real_cnt, stat.addr, test_items[i].addr);
>    307			}
>    308		}
>    309	
>    310		prefix = "kallsyms_on_each_match_symbol() for";
>    311		for (i = 0; i < ARRAY_SIZE(test_items); i++) {
>    312			memset(&stat, 0, sizeof(stat));
>    313			stat.max = INT_MAX;
>    314			stat.name = test_items[i].name;
>    315			kallsyms_on_each_match_symbol(match_symbol, test_items[i].name, &stat);
>    316			if (stat.addr != test_items[i].addr || stat.real_cnt != 1) {
>    317				nr_failed++;
>    318				pr_info("%s %s failed: count=%d, addr=%lx, expect %lx\n",
>    319					prefix, test_items[i].name,
>    320					stat.real_cnt, stat.addr, test_items[i].addr);
>    321			}
>    322		}
>    323	
>    324		if (nr_failed)
>    325			return -ESRCH;
>    326	
>    327		for (i = 0; i < kallsyms_num_syms; i++) {
>    328			addr = kallsyms_sym_address(i);
>    329			if (!is_ksym_addr(addr))
>    330				continue;
>    331	
>    332			ret = lookup_symbol_name(addr, namebuf);
>    333			if (unlikely(ret)) {
>    334				namebuf[0] = 0;
>    335				goto failed;
>    336			}
>    337	
>    338			/*
>    339			 * The first '.' may be the initial letter, in which case the
>    340			 * entire symbol name will be truncated to an empty string in
>    341			 * cleanup_symbol_name(). Do not test these symbols.
>    342			 *
>    343			 * For example:
>    344			 * cat /proc/kallsyms | awk '{print $3}' | grep -E "^\." | head
>    345			 * .E_read_words
>    346			 * .E_leading_bytes
>    347			 * .E_trailing_bytes
>    348			 * .E_write_words
>    349			 * .E_copy
>    350			 * .str.292.llvm.12122243386960820698
>    351			 * .str.24.llvm.12122243386960820698
>    352			 * .str.29.llvm.12122243386960820698
>    353			 * .str.75.llvm.12122243386960820698
>    354			 * .str.99.llvm.12122243386960820698
>    355			 */
>    356			if (IS_ENABLED(CONFIG_LTO_CLANG) && !namebuf[0])
>    357				continue;
>    358	
>    359			lookup_addr = kallsyms_lookup_name(namebuf);
>    360	
>    361			memset(&stat, 0, sizeof(stat));
>    362			stat.max = INT_MAX;
>    363			kallsyms_on_each_match_symbol(match_symbol, namebuf, &stat);
>    364	
>    365			/*
>    366			 * kallsyms_on_each_symbol() is too slow, randomly select some
>    367			 * symbols for test.
>    368			 */
>    369			if (i >= next) {
>    370				memset(&stat2, 0, sizeof(stat2));
>    371				stat2.max = INT_MAX;
>    372				stat2.name = namebuf;
>    373				kallsyms_on_each_symbol(find_symbol, &stat2);
>    374	
>    375				/*
>    376				 * kallsyms_on_each_symbol() and kallsyms_on_each_match_symbol()
>    377				 * need to get the same traversal result.
>    378				 */
>    379				if (stat.addr != stat2.addr ||
>    380				    stat.real_cnt != stat2.real_cnt ||
>    381				    memcmp(stat.addrs, stat2.addrs,
>    382					   stat.save_cnt * sizeof(stat.addrs[0])))
>    383					goto failed;
>    384	
>    385				/*
>    386				 * The average of random increments is 128, that is, one of
>    387				 * them is tested every 128 symbols.
>    388				 */
>    389				get_random_bytes(&rand, sizeof(rand));
>    390				next = i + (rand & 0xff) + 1;
>    391			}
>    392	
>    393			/* Need to be found at least once */
>    394			if (!stat.real_cnt)
>    395				goto failed;
>    396	
>    397			/*
>    398			 * kallsyms_lookup_name() returns the address of the first
>    399			 * symbol found and cannot be NULL.
>    400			 */
>    401			if (!lookup_addr || lookup_addr != stat.addrs[0])
>    402				goto failed;
>    403	
>    404			/*
>    405			 * If the addresses of all matching symbols are recorded, the
>    406			 * target address needs to be exist.
>    407			 */
>    408			if (stat.real_cnt <= MAX_NUM_OF_RECORDS) {
>    409				for (j = 0; j < stat.save_cnt; j++) {
>    410					if (stat.addrs[j] == addr)
>    411						break;
>    412				}
>    413	
>    414				if (j == stat.save_cnt)
>    415					goto failed;
>    416			}
>    417		}
>    418	
>    419		return 0;
>    420	
>    421	failed:
>    422		pr_info("Test for %dth symbol failed: (%s) addr=%lx", i, namebuf, addr);
>    423		return -ESRCH;
>  > 424	}
>    425	
> 

-- 
Regards,
  Zhen Lei
