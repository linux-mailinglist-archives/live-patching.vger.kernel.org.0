Return-Path: <live-patching+bounces-2207-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6OqDA0/gtmn2JwEAu9opvQ
	(envelope-from <live-patching+bounces-2207-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 15 Mar 2026 17:37:35 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 68A6929179C
	for <lists+live-patching@lfdr.de>; Sun, 15 Mar 2026 17:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2E644300826A
	for <lists+live-patching@lfdr.de>; Sun, 15 Mar 2026 16:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AD7365A0D;
	Sun, 15 Mar 2026 16:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DiJz6cjd"
X-Original-To: live-patching@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCA428726A
	for <live-patching@vger.kernel.org>; Sun, 15 Mar 2026 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773592651; cv=none; b=WNeVrTlBmvghB1L8l5fj9dIIA9q4mxtZNnrfAXO8EDTaULktaij/0gOHfzHLFQmk6+hTxE4vio3ddkHRwvbSbFQOVLcaK/VAxCHvRw1UJAO/lc6aub59Ae3Ps0zHOcXeLRsBrd/Bm0z61XfojPkNbHP14eV2VW5TH3C5HIaEsqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773592651; c=relaxed/simple;
	bh=WYrvUmZYKYBIJAq6MuZF2VVUG9+Sg0Vs1TXdFgpWwOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ab8SBvQRMcaMK/MGogPcBFfY68GnG7fuOqIu7AUsJEhKzcjqNr+242+K92TqhrxcDT8rCT5+FwpiO2MDMsdCdll2lMk1STtwd/bKFR79UmXAblXyGlGe0A84V1Zo1hNO3Sum2eW/MUS7c70NgxBitP7Rhl+g1es2BCkEoDKiKWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DiJz6cjd; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <044bebc0-d996-4be3-9330-a64195c19a84@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773592647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KSwYpeETL0sL6LM2+CQsNcn/6oSQ1vhBc3WNrjiMzF0=;
	b=DiJz6cjdi9WmJf1rAnAi3xxChJbBHs3/qLPuhqy6FT0e/tGOOmtS0s20Zu9g0GgeRuud+g
	CL47T6F2SXrKZuuLwHt8Z2u+0ZU5Wkskvgyhb1sWsNtxvFjkX2OmpS4Yt33CYz99+W6DH/
	KuFO/3EeFlXCIoC4o+/nyjD0bEuI3Vs=
Date: Sun, 15 Mar 2026 09:37:22 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH kbuild v2] kbuild: Reduce the number of compiler-generated
 suffixes for clang thin-lto build
To: Nicolas Schier <nsc@kernel.org>, linux-kbuild@vger.kernel.org,
 live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, kernel-team@fb.com,
 Nathan Chancellor <nathan@kernel.org>, Song Liu <song@kernel.org>
References: <20260307050250.3767489-1-yonghong.song@linux.dev>
 <177332462174.82802.2344537821152391518.b4-ty@kernel.org>
Content-Language: en-GB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <177332462174.82802.2344537821152391518.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	URIBL_MULTI_FAIL(0.00)[linux.dev:server fail,sto.lore.kernel.org:server fail];
	TAGGED_FROM(0.00)[bounces-2207-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yonghong.song@linux.dev,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,linux.dev:mid]
X-Rspamd-Queue-Id: 68A6929179C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 3/12/26 7:12 AM, Nicolas Schier wrote:
> On Fri, 06 Mar 2026 21:02:50 -0800, Yonghong Song wrote:
>> The current clang thin-lto build often produces lots of symbols with
>> suffix. The following is a partial list of such function call symbols:
>>      ...
>>      ethnl_module_fw_flash_ntf.llvm.7631589765585346066
>>      __nf_conntrack_alloc.llvm.6438426151906658917
>>      tcp_can_early_drop.llvm.11937612064648250727
>>      tcp_print_conntrack.llvm.11937612064648250727
>>      ...
>>
>> [...]
> Note: Due to application of [1] to kbuild-next-unstable, I had to update the
>        patch context.
>
> [1]: https://lore.kernel.org/linux-kbuild/20251028182822.3210436-1-xur@google.com/
>
>
>
> Applied to kbuild/kbuild-next.git (kbuild-next-unstable), thanks!
>
> [1/1] kbuild: Reduce the number of compiler-generated suffixes for clang thin-lto build
>        https://git.kernel.org/kbuild/c/b7a7ce34
>
> Please look out for regression or issue reports or other follow up
> comments, as they may result in the patch/series getting dropped,
> reverted or modified (e.g. trailers). Patches applied to the
> kbuild-next-unstable branch are accepted pending wider testing in
> linux-next and any post-commit review; they will generally be moved
> to the kbuild-next branch in about a week if no issues are found.

Thanks, Nicolas,

I looked at the patch [1] and find that my patch needs some change.
The current change is

@@ -1047,6 +1047,7 @@ CC_FLAGS_LTO := -flto
else
CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit
+KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility 
-mllvm -always-rename-promoted-locals=false)
endif
CC_FLAGS_LTO += -fvisibility=hidden Due to [1], the above change should 
be @@ -1047,6 +1047,7 @@ CC_FLAGS_LTO := -flto
else
CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit
+if CONFIG_LTO_CLANG_THIN
+KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility 
-mllvm -always-rename-promoted-locals=false)
+endif
endif
CC_FLAGS_LTO += -fvisibility=hidden

The reason likes below:

The patch [1] introduced CONFOG_LTO_CLANG_THIN_DIST and in Makefile, for the following change:

  ifdef CONFIG_LTO_CLANG
-ifdef CONFIG_LTO_CLANG_THIN -CC_FLAGS_LTO := -flto=thin 
-fsplit-lto-unit -else +ifdef CONFIG_LTO_CLANG_FULL  CC_FLAGS_LTO	:= -flto
+else +CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit  endif
  CC_FLAGS_LTO	+= -fvisibility=hidden

The else branch 'CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit' will support both CONFIG_LTO_CLANG_THIN and CONFIG_LTO_CLANG_THIN_DIST.

My patch commit message mentioned that the new flag won't support
thinlto distributed mode yet. So The new ldflags
   $(call ld-option,--lto-whole-program-visibility -mllvm 
-always-rename-promoted-locals=false) needs under LTO_CLANG_THIN but not 
LTO_CLANG_THIN_DIST. There will be some effort in llvm to support 
distributed thin-lto as well for suffix reduction. But it may take a 
little bit time as llvm needs some infrastructure change before 
supporting distributed thin-lto. Thanks!

>
> Best regards,


