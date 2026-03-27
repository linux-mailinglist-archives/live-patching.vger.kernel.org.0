Return-Path: <live-patching+bounces-2266-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDSDEA2LxmlELgUAu9opvQ
	(envelope-from <live-patching+bounces-2266-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 14:50:05 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2CE345953
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 14:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9A123074A3B
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 13:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D60C3ED5BD;
	Fri, 27 Mar 2026 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YFLlAehf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B3039901C
	for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774619026; cv=none; b=KY7/yJcNDVs0AKNF1trfygGX+kmxzNZjBOigYJuycBcvfC5oOJkhQAMZPzOQzaqXRMiaYfQ+e89GCfgFLkk7H/wHCVNHiEYWemuKo3bM2PkAaAimz+/AC9NFB9zYQkizoUiSM53jw9pjHOTc6pqYLInGndUwZxPNcyUdT3IqpSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774619026; c=relaxed/simple;
	bh=xnpOtbtAnF6ZHQ8pPCVM9kiHlVMfUfTM5ad6nkFx99I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kAcURYOKtwBj3mzLv+vl6hTI/iLq3ib1BMQ9bGjPnHSW8pEsAAB7Xn+/BAWBL9SwRhSwrbLdpeEJeLysvuYeNTeuZNoA6h8zFqXCgonHRisIw9BbYA90M8XqKCPtAVspxHJI0TEwcs42eNEijAR9OBegL2Lk0X8BwelgoWOKwhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YFLlAehf; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-483487335c2so23215665e9.2
        for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 06:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774619022; x=1775223822; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YKsHeKZ6OpS0YnJ+ugq57cVpBwIG5Py5vDHb5pEObDI=;
        b=YFLlAehfqhLWrlDbgmz/3b4MFjgclYxL70mpBaZSAdYANAetUWX8ea9vC7YqLTUCmZ
         sKyrywoFxcVBKMIvZSjn9CQgJaIU74y8pQ2RdNrN+BPn416X4dgusJP3VmfLekjLz6BL
         1BqyLlAh11iW8UBoppmoNKeaFyhSFkbWCcbZwhEKKQn8WZ1TXWXWeRdiUQBxYHut2Q+Y
         2VmDCL8OF3qRs5ZbhcCGv+uUu9WY305ExTs1ycUIXzPtPiN7YU05V9EasJT0fZwVQETk
         KSdWntCYIF9ATFeVXE78W1du4MSJr6vWDcokdKaLIaAwLqlJYbzdaa5vbLiwDoq50wxc
         ymUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774619022; x=1775223822;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YKsHeKZ6OpS0YnJ+ugq57cVpBwIG5Py5vDHb5pEObDI=;
        b=V5In1OLx8TavyeoZhMtsKJDBjqUbOaMN3uy6kR3XH6TseEbsCoHxZ+tGtbl6DidD8k
         V096JTs9PCHcmLB1qZ7bG7uhXSWtGhWmzdESdtxkp945wFlo8BSLD5T9aYpRl5ZVEyVk
         jfNF7Q4g3wqYMhSYpt2/F34lzSaeLrMTSJ6xHaUENSXLHw+ju+Lm4INh/n+fuAkCBs1b
         W9ohnreyvGxyj24aX0cXSx8pwdKKf5lhImmuPcJs9nngh5wUfVab5SCXYQYaocslugYR
         n8h5xCYML6gZpbXTF5UE9fsspj1hAkqFE6pvAP4D1+jwVzJsYtaXqt5mOH11GcIe4X87
         LU6Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0eRCmUPIgWIZJwHQb0rft/qnH6lOlRyuTsrUMUqY14Vz3iFGhqkSDbvbdNZRQ3tmpa1bdPSF7eXtWaU+W@vger.kernel.org
X-Gm-Message-State: AOJu0YwPOq5LHdjK/7YZhyHE0HvlVZvoSOF1V17pwyIaqW/5nnxtGx93
	RIrch6rChfefk0YUpwqHxe1uF9k1t5cR5ms5js7cpSiBQJVz1+PdhGkxGd6Qpprrk4Q=
X-Gm-Gg: ATEYQzydLTffafItDqZQXbK21+xaZwaV5hXvIHrptNWyxYp14BIx7VqEnAhczubc1wz
	4146qmLeq4rNVyY+tJk9UezvqaNdHaHJtYJDA+pBWhYW24LW1gbKkvkzVigp2F62fP02UIA8EzT
	gU1VQCq9rE+8VH76d6YYxKA2uBReup0mSP0bIHhzhyptEEhB5RwvZWQ/vi6UXsWsm0w1CwLzHYF
	mHXzDaVXvAMk8wjEb6Ns89X3gRbQB0yGKe8BOOc/VNZDHV1Dc4fEE9/6FrNYD3zpmIJqcB/xnm9
	q0xOL4MaCTGWD1HfmixxIDRrPZnV4mPXLas3iER9vX5mPT6BdMl9sxS92kF7TF+K4aipLHgkaAx
	D0XBNhHW1f8evkHgSjk2jPsJkE9o69ecBNptNoBTws+jh5HTRCA8Q875A2UG/y+WUZe9uWt5kz4
	B2yL+TFxjKiIcPZApbZiqYhtY7etBskKvSIyyQKZc5h+6DEnaQCY5DtevdEoUgfSkr0HSlhA==
X-Received: by 2002:a05:600c:3510:b0:486:ffa3:593 with SMTP id 5b1f17b1804b1-487280abccdmr37007085e9.28.1774619021707;
        Fri, 27 Mar 2026 06:43:41 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:c8ca:fb24:208a:b63f? ([2804:1bc4:224:7800:c8ca:fb24:208a:b63f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487270c3393sm25085205e9.4.2026.03.27.06.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 06:43:40 -0700 (PDT)
Message-ID: <47ef161f2574a49e591b87948ecaa635210c9b39.camel@suse.com>
Subject: Re: [PATCH 3/8] selftests: livepatch: test-kprobe: Check if kprobes
 can work with livepatches
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>,  Jiri Kosina <jikos@kernel.org>, Miroslav Benes
 <mbenes@suse.cz>, Shuah Khan <shuah@kernel.org>, 
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Fri, 27 Mar 2026 10:43:35 -0300
In-Reply-To: <ab0wiEuokqDwq5_v@pathway.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
	 <20260313-lp-tests-old-fixes-v1-3-71ac6dfb3253@suse.com>
	 <abhqRTBtF1hLDmPq@redhat.com>
	 <c4249fb8b36aba8649e4dcdac022f2d646413756.camel@suse.com>
	 <ab0wiEuokqDwq5_v@pathway.suse.cz>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2266-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 8F2CE345953
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 2026-03-20 at 12:33 +0100, Petr Mladek wrote:
> On Thu 2026-03-19 11:35:16, Marcos Paulo de Souza wrote:
> > On Mon, 2026-03-16 at 16:38 -0400, Joe Lawrence wrote:
> > > On Fri, Mar 13, 2026 at 05:58:34PM -0300, Marcos Paulo de Souza
> > > wrote:
> > > > Running the upstream selftests on older kernels can presente
> > > > some
> > > > issues
> > > > regarding features being not present. One of such issues if the
> > > > missing
> > > > capability of having both kprobes and livepatches on the same
> > > > function.
> > > >=20
> > >=20
> > > nit picking, but slightly reworded for clarity and spelling:
> > >=20
> > > Running upstream selftests on older kernels can be problematic
> > > when
> > > features or fixes from newer versions are not present. For
> > > example,
> > > older kernels may lack the capability to support kprobes and
> > > livepatches
> > > on the same function simultaneously.
> >=20
> > Much better, I'll pick your description for v2.
> >=20
> > >=20
> > > > The support was introduced in commit 0bc11ed5ab60c
> > > > ("kprobes: Allow kprobes coexist with livepatch"), which means
> > > > that
> > > > older
> > > > kernels may lack this change.
> > > >=20
> > > > The lack of this feature can be checked when a kprobe without a
> > > > post_handler is loaded and checking that the enabled_function's
> > > > file
> > > > shows the flag "I". A kernel with the proper support for
> > > > kprobes
> > > > and
> > > > livepatches would presente the flag only when a post_handler is
> > >=20
> > > nit: s/presente/present
> >=20
> > > > --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> > > > +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> > > > @@ -16,30 +16,19 @@ setup_config
> > > > =C2=A0# when it uses a post_handler since only one IPMODIFY maybe b=
e
> > > > registered
> > > > =C2=A0# to any given function at a time.
> > > > =C2=A0
> > > > -start_test "livepatch interaction with kprobed function with
> > > > post_handler"
> > > > -
> > > > -echo 1 > "$SYSFS_KPROBES_DIR/enabled"
> > > > -
> > > > -load_mod $MOD_KPROBE has_post_handler=3D1
> > > > -load_failing_mod $MOD_LIVEPATCH
> > > > -unload_mod $MOD_KPROBE
> > > > -
> > > > -check_result "% insmod test_modules/test_klp_kprobe.ko
> > > > has_post_handler=3D1
> > > > -% insmod test_modules/$MOD_LIVEPATCH.ko
> > > > -livepatch: enabling patch '$MOD_LIVEPATCH'
> > > > -livepatch: '$MOD_LIVEPATCH': initializing patching transition
> > > > -livepatch: failed to register ftrace handler for function
> > > > 'cmdline_proc_show' (-16)
> > > > -livepatch: failed to patch object 'vmlinux'
> > > > -livepatch: failed to enable patch '$MOD_LIVEPATCH'
> > > > -livepatch: '$MOD_LIVEPATCH': canceling patching transition,
> > > > going
> > > > to unpatch
> > > > -livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> > > > -livepatch: '$MOD_LIVEPATCH': unpatching complete
> > > > -insmod: ERROR: could not insert module
> > > > test_modules/$MOD_LIVEPATCH.ko: Device or resource busy
> > > > -% rmmod test_klp_kprobe"
> > > > -
> > > > =C2=A0start_test "livepatch interaction with kprobed function
> > > > without
> > > > post_handler"
> > > > =C2=A0
> > > > =C2=A0load_mod $MOD_KPROBE has_post_handler=3D0
> > > > +
> > > > +# Check if commit 0bc11ed5ab60c ("kprobes: Allow kprobes
> > > > coexist
> > > > with livepatch")
> > > > +# is missing, meaning that livepatches and kprobes can't be
> > > > used
> > > > together.
> > > > +# When the commit is missing, kprobes always set IPMODIFY (the
> > > > I
> > > > flag), even
> > > > +# when the post handler is missing.
> > > > +if grep --quiet ") R I"
> > > > "$SYSFS_DEBUG_DIR/tracing/enabled_functions"; then
> > >=20
> > > Will flags R I always be in this order?
> >=20
> > 		seq_printf(m, " (%ld)%s%s%s%s%s",
> > 			=C2=A0=C2=A0 ftrace_rec_count(rec),
> > 			=C2=A0=C2=A0 rec->flags & FTRACE_FL_REGS ? " R" : "=C2=A0
> > ",
> > 			=C2=A0=C2=A0 rec->flags & FTRACE_FL_IPMODIFY ? " I"
> > : "=20
> > ",
> >=20
> > So this is safe. I'll add a comment in the patch to explain why
> > this is
> > safe too. Thanks for the comment!
>=20
> I would personally check also "cmdline_proc_show" to make sure that
> the line is about this function. Something like:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 grep --quiet ") "cmdline_proc_show.*([0-9]\+) R"
>=20
>=20
> But I am afraid that this approach is not good. It breaks the test.
> It won't longer be able to catch regressions when the kprobe
> sets "FTRACE_FL_IPMODIFY" by mistake again.
>=20
> We could add a version check. But it would break users who backport
> the fix into older kernels.
>=20
> IMHO, the best solution would be to keep the test as is.
> Whoever is running the test with older kernels should mark it
> as "failure-expected". The test is pointing out an existing problem
> in the old kernel. IMHO, it should not hide it.

Makes sense, thanks for your review Petr. I'll drop this patch from v2.

>=20
> Best Regards,
> Petr

