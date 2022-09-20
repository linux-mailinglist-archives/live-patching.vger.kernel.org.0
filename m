Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98A75BDAC0
	for <lists+live-patching@lfdr.de>; Tue, 20 Sep 2022 05:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiITDPn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Sep 2022 23:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiITDPf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Sep 2022 23:15:35 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA80513FA8;
        Mon, 19 Sep 2022 20:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663643718; x=1695179718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0xmeP7bbIPEvgr7OHnrVDNezLI0+wyzTyhuQOnioe2E=;
  b=K5T7A9XSgQOK+8KTaoBYi4jkOIQbuzgtAkGA2ewdXoFq2wDy0x+Tjdmz
   +E7Xh43TAqMG5ubUXzRH2VOSeBIz3Rq5t51wDr7tNYud72Ffl2ZT9I2Yj
   4yzdK092M0L3CwDKMg5XdfDVFOvgEiefZpZ38k/tTDaQdZCkMydZGZOhZ
   BpG41yhcExGIULNTPBqPSkW7LiqmmZdNJYeLeGKL8OIV0GAiwiHwRNEil
   sKRB60Ln/igkPrMcGzIJvRWGhoYtgEMZdS/Hu28+Nc8lv+zO3BCLt3QQI
   wmsbPzXmwR6kX5tP9HJO9x10aIQx8JUlXoXto+lWzFCrG1aVtp4+LV4eL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="297174702"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="297174702"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 20:14:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="947487099"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 19 Sep 2022 20:14:54 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oaTin-0002RY-1p;
        Tue, 20 Sep 2022 03:14:53 +0000
Date:   Tue, 20 Sep 2022 11:14:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: Re: [PATCH v3 8/8] kallsyms: Add self-test facility
Message-ID: <202209201126.fpHaqBEx-lkp@intel.com>
References: <20220919151533.1734-9-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919151533.1734-9-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Zhen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mcgrof/modules-next]
[also build test WARNING on linus/master v6.0-rc6 next-20220919]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20220919-231916
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git modules-next
config: arm-nhk8815_defconfig (https://download.01.org/0day-ci/archive/20220920/202209201126.fpHaqBEx-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/26fdb8f3984ffbdb57da2d1fac7e32ae418bfa96
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Zhen-Lei/kallsyms-Optimizes-the-performance-of-lookup-symbols/20220919-231916
        git checkout 26fdb8f3984ffbdb57da2d1fac7e32ae418bfa96
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/kallsyms.c:196:15: warning: no previous prototype for 'kallsyms_sym_address' [-Wmissing-prototypes]
     196 | unsigned long kallsyms_sym_address(int idx)
         |               ^~~~~~~~~~~~~~~~~~~~
   kernel/kallsyms.c:668:12: warning: no previous prototype for 'arch_get_kallsym' [-Wmissing-prototypes]
     668 | int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
         |            ^~~~~~~~~~~~~~~~


vim +/kallsyms_sym_address +196 kernel/kallsyms.c

   195	
 > 196	unsigned long kallsyms_sym_address(int idx)
   197	{
   198		if (!IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE))
   199			return kallsyms_addresses[idx];
   200	
   201		/* values are unsigned offsets if --absolute-percpu is not in effect */
   202		if (!IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU))
   203			return kallsyms_relative_base + (u32)kallsyms_offsets[idx];
   204	
   205		/* ...otherwise, positive offsets are absolute values */
   206		if (kallsyms_offsets[idx] >= 0)
   207			return kallsyms_offsets[idx];
   208	
   209		/* ...and negative offsets are relative to kallsyms_relative_base - 1 */
   210		return kallsyms_relative_base - 1 - kallsyms_offsets[idx];
   211	}
   212	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
