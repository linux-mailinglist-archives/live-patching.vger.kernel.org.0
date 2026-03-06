Return-Path: <live-patching+bounces-2156-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id BtySBIBRq2n3cAEAu9opvQ
	(envelope-from <live-patching+bounces-2156-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 23:13:20 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE8E2283C0
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 23:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BADD230297A7
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 22:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EAC3EDAC2;
	Fri,  6 Mar 2026 22:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vOCfAEu2"
X-Original-To: live-patching@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B93E3EB7EA
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 22:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772835183; cv=none; b=acZX5Osyz4o/zzNJFvSbx4k6DiB2RviMszwvYWa/M9dLZ1pOqk5UtDpmrjyD6rJAQVKn77NABwwblrPASwplH6xkgWS78n9ngKkcd4kfJvK0SUQj0dptUeyxKzeLdgl+m31nyt74sD6EQp0WMzHrQzesybgwteHEfM5fN2A1JZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772835183; c=relaxed/simple;
	bh=80ZunVhiXbrrR0iGJ3MYR88cf/HpWcPTL7XUmZffqQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K8HEhZz3zlp6BW+JCBR5C2Tw50EszZdb/M6zF7J2PHquKZdZRbrAO7yAg1wI9KUuCvzYa93xHagpB/eylru13xI1qf7MIY0dgjNkfkwFjgxW2wJKrOdQIn0Y0ysGIfIp4JLLOX6zSazToGeNczq2+OR3qFmhtXyxElhkT6ePCLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vOCfAEu2; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <f0c037e6-d498-41c3-8d71-0597a2e1d68d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772835169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1KakKH2y1noe+d5WaCyUn8YxyuOtCqYL0qCHg4LzN0=;
	b=vOCfAEu2h+WIsx/ocySltxVYlwCi8w6FcCdvYe/u8FoyK6CBhQi5lTOCVeM4iTQHaKgu/b
	j5JSujWWBmLuIkN9H24cIPFy1GluZokeZL9PruifwF57uPeCPmWgC7F98bWAyqy3Gsg0Vj
	TejjKcWN06kT/6x0l2Wwc/JwPxt6SfY=
Date: Fri, 6 Mar 2026 14:12:44 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH kbuild] kbuild: Allow to reduce the number of suffixes for
 clang thin-lto build
Content-Language: en-GB
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
 kernel-team@fb.com, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>,
 yonghong.song@linux.dev
References: <20260306034325.3605301-1-yonghong.song@linux.dev>
 <pat2b5nibiik6nua6ls7cu7eqy5qgrugo4gnel32bz6vpcrmz3@f7ynsbvnxcaj>
 <f1afe1e8-0dfd-47b0-8ca4-f09d4fda13eb@linux.dev>
 <bt7t2452h27o7bf27f7ljs2xhn7venhvslynq3a77jbtwi7hqk@cgobhbhi5y2r>
 <lmj53l5djuipucmuxwr563n6ty7hobduzg4vvy4pjnw4yz5t56@he3wiioegzhy>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <lmj53l5djuipucmuxwr563n6ty7hobduzg4vvy4pjnw4yz5t56@he3wiioegzhy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EEE8E2283C0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2156-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yonghong.song@linux.dev,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.935];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,linux.dev:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action



On 3/6/26 12:57 PM, Josh Poimboeuf wrote:
> On Fri, Mar 06, 2026 at 12:55:02PM -0800, Josh Poimboeuf wrote:
>> On Fri, Mar 06, 2026 at 11:40:21AM -0800, Yonghong Song wrote:
>>>> Thanks!  Would there be any downsides to enabling this feature
>>>> unconditionally in the kernel when the compiler supports it?
>>> The only downside is for the following case:
>>>
>>> C   file: static function foo()
>>> Asm file: global function foo()
>>>
>>> The thin-lto will collect all C files and with the above llvm patch,
>>> the static function foo() may be promoted to global function foo()
>>> if there is no other pre-existing global function foo() in all C files.
>>>
>>> In such cases, there will be a conflict since
>>> there are two global function foo() (one from C file, another from Asm file).
>>> In such cases, the build will fail.
>>>
>>> How do you think we could hit such issues in linux kernel?
>>> Maybe should have default no for the new config?
>>>
>>> I think the chance should be very low. The following is a grab for x86
>>> for global symbols in asm code:
>>>
>>> [~/work/others/linux/arch/x86 (master)]$ egrep -r globl
>> There are actually quite a bit more than that, see SYM_CODE_START:
>>
>>    $ git grep 'SYM_CODE_START(' |wc -l
>>    169
>>
>> But still, I agree the chance of a conflict would be very low.  And
>> global assembly functions tend to be rather uniquely named.
>>
>>> Maybe we could collect all global symbols in asm codes before lld,
>>> and then we add an option in lld to feed those global symbols (with a file?),
>>> then we can be sure there won't be any conflict?
>> That wouldn't be worth the effort in my opinion.
>>
>> I think we should just unconditionally enable
>> -always-rename-promoted-locals=false when it's available.  While that
>> will implicitly enforce that global asm functions be uniquely named
>> across the tree, I don't see that as a problem.  In the rare case of a
>> conflict, we can just rename the function.

So you mean we do not need a new config. Should just check clang and
clang versionn like below?

diff --git a/Makefile b/Makefile
index e944c6e71e81..9bd3990024c5 100644
--- a/Makefile
+++ b/Makefile
@@ -1034,6 +1034,11 @@ endif
  ifdef CONFIG_LTO_CLANG
  ifdef CONFIG_LTO_CLANG_THIN
  CC_FLAGS_LTO   := -flto=thin -fsplit-lto-unit
+ifdef CONFIG_CC_IS_CLANG
+ifeq ($(shell test $(CONFIG_CLANG_VERSION) -ge 230000; echo $$?),0)
+KBUILD_LDFLAGS += --lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false
+endif
+endif
  else
  CC_FLAGS_LTO   := -flto
  endif

I think this should work. In rare case, renaming the function should
solve the problem.

> BTW, reading this again I realize that this would affect not only global
> asm *functions*, but also global asm *data*.  But asm global data is
> quite rare and also tends to be uniquely named, so my conclusion is the
> same.
>
With thin-lto, the cross-file data inlining is a side effect of
cross-file function inlining. So the number of cross-file data inlining
is small. Compared to 1212 number of functions with suffix .llvm.<hash>,
the number of data with suffix only 9:

ffffffff84e8ad09 d __func__.net_ratelimit.llvm.12310750674033017485
ffffffff84f1d569 d .str.llvm.11541892489833206993
ffffffff87f42d40 b __cfs_bandwidth_used.llvm.9245315756205243639
ffffffff87f457c0 b __sched_clock_stable.llvm.13183765431478218167
ffffffff881968d0 b lock_chains_in_use.llvm.17116087415131265585
ffffffff88bba180 b timekeeper_data.llvm.4127123038948722377
ffffffff88bd0eb0 b slab_debugfs_root.llvm.537776758349482510
ffffffff88c0b300 b __acpi_os_prepare_sleep.llvm.3969442148434754585
ffffffff88c63b00 b handshake_rhashtbl.llvm.12810142853876704317

With newly added KBUILD_LDFLAGS flags, none of them have suffixes.
Again, the conflict for data variable should be rare too.

I will repost the patch with Makefile change once llvm23 release
is cut.

Thanks!


