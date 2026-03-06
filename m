Return-Path: <live-patching+bounces-2153-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJeJDcEtq2n6aQEAu9opvQ
	(envelope-from <live-patching+bounces-2153-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 20:40:49 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 23682227259
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 20:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3BED9300A58A
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 19:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1778423A68;
	Fri,  6 Mar 2026 19:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mJHR5yjV"
X-Original-To: live-patching@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA7F334373
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 19:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772826040; cv=none; b=eUNA7nMmtzjlI8oCeVhm5Zphw4U2kvBYPqdJIuA21p7mGb/Dsu/0A8MmO2n4xTcfyVrMMO1GhDT77cQw0Al5LzUSwSuc7mxngFexw68HAkGmINYgaw1tEDxTLRdvvpPlgelX/pfgj23Q6EBJxMr4qs9t5HE1iwynDi0u1ppXCP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772826040; c=relaxed/simple;
	bh=FzoX8JXBwV1OXB+dnpLRw6Ns6uCBf2HLtxy3pM/gPdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RQFFxPKjd57TM9fUe2FkpEwvg+skWJM4WbvDVUhd915i3G5urqV5WD8BRl3ZQwgvrM96x5YdajLqr6Ikn5m2/DdniOEjgWCg1UMOga72d08xmtJM8mXl7JH+DM6mRdJAzJlH57bWW7xrEXpqcqfxbt3AXZ5o7R6ntRdnXT92ZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mJHR5yjV; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <f1afe1e8-0dfd-47b0-8ca4-f09d4fda13eb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772826027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SD7VATjAwYLJswCrUmqN13M+ghZRIBgOhiRyPc44W3o=;
	b=mJHR5yjVaf91hAgzLj8kXUOxNwH2e9mbGBcfo2hRQ6MZnbjOPb/DNz41D22VNgvYe4Mgjr
	DZBsqzZVM0D8o7g+dnvsoqk8Bc5uQt3rpgXkRMI/GhXc2eHLvL4SLwe6IYq0JCNRcHwqyz
	brsVS5bAtRHGdKeJzseEJ4PahQ7DudI=
Date: Fri, 6 Mar 2026 11:40:21 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH kbuild] kbuild: Allow to reduce the number of suffixes for
 clang thin-lto build
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
 kernel-team@fb.com, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>
References: <20260306034325.3605301-1-yonghong.song@linux.dev>
 <pat2b5nibiik6nua6ls7cu7eqy5qgrugo4gnel32bz6vpcrmz3@f7ynsbvnxcaj>
Content-Language: en-GB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <pat2b5nibiik6nua6ls7cu7eqy5qgrugo4gnel32bz6vpcrmz3@f7ynsbvnxcaj>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 23682227259
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2153-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yonghong.song@linux.dev,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.935];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,linux.dev:email,linux.dev:mid,lpc.events:url,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,llvm.org:url]
X-Rspamd-Action: no action



On 3/6/26 10:32 AM, Josh Poimboeuf wrote:
> On Thu, Mar 05, 2026 at 07:43:25PM -0800, Yonghong Song wrote:
>> The current clang thin-lto build often produces lots of symbols with
>> suffix. The following is a partial list of such function call symbols:
>>      ...
>>      ethnl_module_fw_flash_ntf.llvm.7631589765585346066
>>      __nf_conntrack_alloc.llvm.6438426151906658917
>>      tcp_can_early_drop.llvm.11937612064648250727
>>      tcp_print_conntrack.llvm.11937612064648250727
>>      ...
>>
>> In my particular build with current bpf-next, the number of '*.llvm.<hash>'
>> function calls is 1212. Such symbols make kernel live patching
>> difficult since
>>    - a minor code change will change the hash and then the '*.llvm.<hash>'
>>      symbol becomes another one with a different hash or no hash, and
>>    - a previous source-level symbol may become an one with suffix after live
>>      patching code.
>>
>> In [1], Song Liu suggested to reduce the number of '*.llvm.<hash>' functions
>> to make live patch easier. In respond of this, I implemented this
>> in llvm ([2]). The same thin-lto build with [2] only has two symbols with
>> suffix:
>>      m_stop.llvm.14460341347352036579
>>      m_next.llvm.14460341347352036579
>> This should make live patch much easier.
>>
>> To support suffix symbol reduction, a new config
>>      LTO_CLANG_THIN_SUFFIX_REDUCTION
>> is introduced and the config depends on thin-lto and llvm23 or higher.
>>
>> Two lld flags are necessary to enable this feature in kernel:
>>      - Flag '--lto-whole-program-visibility' is needed as it ensures that all
>>        modules are available in the same process, which is true for kernel at
>>        thin-lto lld.
>>      - Flag '-mllvm -always-rename-promoted-locals=false' is needed to enable
>>        suffix reduction. Currently in llvm [1], only process mode is supported.
>>        There is another distributed mode (across different processes or even
>>        different machines) which is not supported yet ([2]).
>>
>>    [1] https://lpc.events/event/19/contributions/2212
>>    [2] https://github.com/llvm/llvm-project/pull/178587
>>
>> Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
>> ---
>>   Makefile     |  3 +++
>>   arch/Kconfig | 15 +++++++++++++++
>>   2 files changed, 18 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index e944c6e71e81..9d6033595615 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1034,6 +1034,9 @@ endif
>>   ifdef CONFIG_LTO_CLANG
>>   ifdef CONFIG_LTO_CLANG_THIN
>>   CC_FLAGS_LTO	:= -flto=thin -fsplit-lto-unit
>> +ifdef CONFIG_LTO_CLANG_THIN_SUFFIX_REDUCTION
>> +KBUILD_LDFLAGS += --lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false
>> +endif
>>   else
>>   CC_FLAGS_LTO	:= -flto
>>   endif
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 102ddbd4298e..e1db64a3284e 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -861,8 +861,23 @@ config LTO_CLANG_THIN
>>   	    https://clang.llvm.org/docs/ThinLTO.html
>>   
>>   	  If unsure, say Y.
>> +
>>   endchoice
>>   
>> +config LTO_CLANG_THIN_SUFFIX_REDUCTION
>> +	bool "Clang ThinLTO Suffix Reduction (EXPERIMENTAL)"
>> +	depends on LTO_CLANG_THIN
>> +	depends on CLANG_VERSION >= 230000
>> +	default y
>> +	help
>> +	  This option allows to reduce the number of symbols with
>> +	  '.llvm.<hash' suffixes. This can help KLP (kernel living
>> +	  patch) as symbol name can stay stable in most cases.
>> +
>> +	  See https://github.com/llvm/llvm-project/pull/178587
>> +
>> +	  If unsure, say N.
>> +
> Thanks!  Would there be any downsides to enabling this feature
> unconditionally in the kernel when the compiler supports it?

The only downside is for the following case:

C   file: static function foo()
Asm file: global function foo()

The thin-lto will collect all C files and with the above llvm patch,
the static function foo() may be promoted to global function foo()
if there is no other pre-existing global function foo() in all C files.

In such cases, there will be a conflict since
there are two global function foo() (one from C file, another from Asm file).
In such cases, the build will fail.

How do you think we could hit such issues in linux kernel?
Maybe should have default no for the new config?

I think the chance should be very low. The following is a grab for x86
for global symbols in asm code:

[~/work/others/linux/arch/x86 (master)]$ egrep -r globl
egrep: warning: egrep is obsolescent; using grep -E
boot/compressed/mkpiggy.c:      printf(".globl z_input_len\n");
boot/compressed/mkpiggy.c:      printf(".globl z_output_len\n");
boot/compressed/mkpiggy.c:      printf(".globl input_data, input_data_end\n");
boot/compressed/mkpiggy.c:      printf(".globl input_len\n");
boot/compressed/mkpiggy.c:      printf(".globl output_len\n");
boot/compressed/head_64.S:      .globl  verify_cpu
boot/bioscall.S:        .globl  intcall
boot/header.S:  .globl  pecompat_fstart
boot/header.S:  .globl  sentinel
boot/header.S:  .globl  hdr
boot/header.S:  .globl  _start
boot/header.S:          .globl realmode_swtch
boot/header.S:  .globl  die
entry/vdso/vdso32/sigreturn.S:  .globl __kernel_sigreturn
entry/vdso/vdso32/sigreturn.S:  .globl __kernel_rt_sigreturn
entry/vdso/vdso32/system_call.S:        .globl __kernel_vsyscall
entry/vsyscall/vsyscall_emu_64.S:       .globl __vsyscall_page
entry/entry_32.S:       .globl __irqentry_text_start
entry/entry_32.S:       .globl __irqentry_text_end
entry/entry_64.S:       .globl __irqentry_text_start
entry/entry_64.S:       .globl __irqentry_text_end
include/asm/paravirt_types.h:       ".globl " PV_THUNK_NAME(func) ";"                           \
include/asm/static_call.h:          ".globl " STATIC_CALL_TRAMP_STR(name) "             \n"     \
kernel/cpu/amd.c:       ".globl vide\n"
kernel/ftrace_32.S:.globl ftrace_call
kernel/ftrace_32.S:.globl ftrace_graph_call
kernel/ftrace_32.S:.globl return_to_handler
kernel/relocate_kernel_32.S:    .globl kexec_control_code_size
kernel/head_32.S:.globl initial_pg_pmd
kernel/head_32.S:.globl initial_page_table
kernel/head_32.S:.globl swapper_pg_dir
kernel/head_32.S:.globl empty_zero_page
lib/error-inject.c:     ".globl just_return_func\n"
math-emu/reg_round.S:.globl fpu_reg_round
math-emu/reg_round.S:.globl fpu_Arith_exit
purgatory/kexec-purgatory.S:    .globl  kexec_purgatory
purgatory/kexec-purgatory.S:    .globl  kexec_purgatory_size
um/setjmp_32.S: .globl kernel_setjmp
um/setjmp_32.S: .globl kernel_longjmp
um/setjmp_64.S: .globl kernel_setjmp
um/setjmp_64.S: .globl kernel_longjmp
xen/xen-head.S: ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          .globl xen_elfnote_entry;
[~/work/others/linux/arch/x86 (master)]$

Maybe we could collect all global symbols in asm codes before lld,
and then we add an option in lld to feed those global symbols (with a file?),
then we can be sure there won't be any conflict?



