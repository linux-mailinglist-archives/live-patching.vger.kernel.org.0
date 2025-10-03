Return-Path: <live-patching+bounces-1728-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD81CBB6872
	for <lists+live-patching@lfdr.de>; Fri, 03 Oct 2025 13:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50ED219C6A29
	for <lists+live-patching@lfdr.de>; Fri,  3 Oct 2025 11:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B6B2EB864;
	Fri,  3 Oct 2025 11:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bAdlNTgn"
X-Original-To: live-patching@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824A82E9ED7;
	Fri,  3 Oct 2025 11:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759490529; cv=none; b=KIEkotKBK1a9g/TjiMoR0BRkNTIvA6oyy8NCSHK8zl058DA/1s9hwwbjsZFBn+YNOQzU8Z1n5VZL2SkOmvnlUZ+5+SSXI6AcND5uodcO6l0X5eDujSIwklWZHRbyL7Gogy6KW6/Nk6OlNAovQ34ZlUk1bzvS7dmqFgzmIB4GhlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759490529; c=relaxed/simple;
	bh=SQ0wWE5s+n+etYy51keKtH5RFeBQ0HfzRhF5vbYQQLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+f6eldKdyc0GpYkZUpZuDU7mDmH8G6KEoMz3WdBjvSxq/fCGWOxSHxPlhxR36R3G1K72BP0iBBUllX+st+S2KvfIrr1q376Y9LzgtarLUWlkEyuWBNVzFc2Xx5/8wqNzamWyqtq0EVrCthTJGiXXSWduQsBEXzVq//oPIRV+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bAdlNTgn; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759490527; x=1791026527;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SQ0wWE5s+n+etYy51keKtH5RFeBQ0HfzRhF5vbYQQLs=;
  b=bAdlNTgnO06tQv/3hrJ5ZHeiqs6gqnxhcTUBWx6SilKkHAG3bl/Rnbrk
   k2HLqIAOimRwuWOT5Hc1GApctl2NyZY/LufMvhKoDRZpMYJB/ec29mxqI
   tNgXAO3fbU2ZxA3ikxaJfKJxwSyDDhIdclAU1vuy5v77F2Uks+J2019Ic
   fM5XL1c1mXwPgCr9p1sXCRfPmQ1dYyicTSSYnWWQYrkkAwcHQGBSx+S5t
   c90GDPMimYZflmAUwV3jiUbtFilQ9hQA2iwwNhBbP3r4hPJfV6DzIksd1
   Ca+OfMC52VZoCpjf31jP3FIT6wRoiCrZYEnkbSwY3kRpT5EVQCwhiW8sK
   A==;
X-CSE-ConnectionGUID: JIlTvgfxSceP/8vz3TjbaQ==
X-CSE-MsgGUID: 0vZ0OV26R2eyfxwwZA/35g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65598994"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65598994"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 04:22:07 -0700
X-CSE-ConnectionGUID: A2+NWnNvTceCQPXkBdgigg==
X-CSE-MsgGUID: yuKJlNbaQEGhIEug+NUPYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="179080867"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 03 Oct 2025 04:22:02 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v4drK-0004Vj-2C;
	Fri, 03 Oct 2025 11:21:58 +0000
Date: Fri, 3 Oct 2025 19:21:53 +0800
From: kernel test robot <lkp@intel.com>
To: Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: oe-kbuild-all@lists.linux.dev,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Naveen N. Rao" <naveen@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
	Viktor Malik <vmalik@redhat.com>, live-patching@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>, linux-trace-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: Re: [PATCH] powerpc64/bpf: support direct_call on livepatch function
Message-ID: <202510031817.t50YvoeN-lkp@intel.com>
References: <20251002192755.86441-1-hbathini@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002192755.86441-1-hbathini@linux.ibm.com>

Hi Hari,

kernel test robot noticed the following build errors:

[auto build test ERROR on powerpc/next]
[also build test ERROR on powerpc/fixes trace/for-next bpf-next/net bpf-next/master bpf/master linus/master v6.17 next-20251002]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hari-Bathini/powerpc64-bpf-support-direct_call-on-livepatch-function/20251003-033243
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git next
patch link:    https://lore.kernel.org/r/20251002192755.86441-1-hbathini%40linux.ibm.com
patch subject: [PATCH] powerpc64/bpf: support direct_call on livepatch function
config: powerpc64-randconfig-001-20251003 (https://download.01.org/0day-ci/archive/20251003/202510031817.t50YvoeN-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251003/202510031817.t50YvoeN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510031817.t50YvoeN-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/powerpc/net/bpf_jit_comp.c:24:
   arch/powerpc/net/bpf_jit_comp.c: In function '__arch_prepare_bpf_trampoline':
>> include/linux/stddef.h:16:33: error: 'struct thread_info' has no member named 'livepatch_sp'
      16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
         |                                 ^~~~~~~~~~~~~~~~~~
   arch/powerpc/net/bpf_jit.h:29:34: note: in definition of macro 'PLANT_INSTR'
      29 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
         |                                  ^~~~~
   arch/powerpc/net/bpf_jit_comp.c:857:17: note: in expansion of macro 'EMIT'
     857 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, offsetof(struct thread_info, livepatch_sp)));
         |                 ^~~~
   arch/powerpc/include/asm/ppc-opcode.h:501:85: note: in expansion of macro 'IMM_L'
     501 | #define PPC_RAW_ADDI(d, a, i)           (0x38000000 | ___PPC_RT(d) | ___PPC_RA(a) | IMM_L(i))
         |                                                                                     ^~~~~
   arch/powerpc/net/bpf_jit_comp.c:857:22: note: in expansion of macro 'PPC_RAW_ADDI'
     857 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, offsetof(struct thread_info, livepatch_sp)));
         |                      ^~~~~~~~~~~~
   arch/powerpc/net/bpf_jit_comp.c:857:47: note: in expansion of macro 'offsetof'
     857 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, offsetof(struct thread_info, livepatch_sp)));
         |                                               ^~~~~~~~
>> arch/powerpc/net/bpf_jit_comp.c:860:48: error: 'LIVEPATCH_STACK_FRAME_SIZE' undeclared (first use in this function)
     860 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, -LIVEPATCH_STACK_FRAME_SIZE));
         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/net/bpf_jit.h:29:34: note: in definition of macro 'PLANT_INSTR'
      29 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
         |                                  ^~~~~
   arch/powerpc/net/bpf_jit_comp.c:860:17: note: in expansion of macro 'EMIT'
     860 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, -LIVEPATCH_STACK_FRAME_SIZE));
         |                 ^~~~
   arch/powerpc/include/asm/ppc-opcode.h:501:85: note: in expansion of macro 'IMM_L'
     501 | #define PPC_RAW_ADDI(d, a, i)           (0x38000000 | ___PPC_RT(d) | ___PPC_RA(a) | IMM_L(i))
         |                                                                                     ^~~~~
   arch/powerpc/net/bpf_jit_comp.c:860:22: note: in expansion of macro 'PPC_RAW_ADDI'
     860 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, -LIVEPATCH_STACK_FRAME_SIZE));
         |                      ^~~~~~~~~~~~
   arch/powerpc/net/bpf_jit_comp.c:860:48: note: each undeclared identifier is reported only once for each function it appears in
     860 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, -LIVEPATCH_STACK_FRAME_SIZE));
         |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/net/bpf_jit.h:29:34: note: in definition of macro 'PLANT_INSTR'
      29 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
         |                                  ^~~~~
   arch/powerpc/net/bpf_jit_comp.c:860:17: note: in expansion of macro 'EMIT'
     860 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, -LIVEPATCH_STACK_FRAME_SIZE));
         |                 ^~~~
   arch/powerpc/include/asm/ppc-opcode.h:501:85: note: in expansion of macro 'IMM_L'
     501 | #define PPC_RAW_ADDI(d, a, i)           (0x38000000 | ___PPC_RT(d) | ___PPC_RA(a) | IMM_L(i))
         |                                                                                     ^~~~~
   arch/powerpc/net/bpf_jit_comp.c:860:22: note: in expansion of macro 'PPC_RAW_ADDI'
     860 |                 EMIT(PPC_RAW_ADDI(_R12, _R12, -LIVEPATCH_STACK_FRAME_SIZE));
         |                      ^~~~~~~~~~~~


vim +16 include/linux/stddef.h

6e218287432472 Richard Knutsson 2006-09-30  14  
^1da177e4c3f41 Linus Torvalds   2005-04-16  15  #undef offsetof
14e83077d55ff4 Rasmus Villemoes 2022-03-23 @16  #define offsetof(TYPE, MEMBER)	__builtin_offsetof(TYPE, MEMBER)
3876488444e712 Denys Vlasenko   2015-03-09  17  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

