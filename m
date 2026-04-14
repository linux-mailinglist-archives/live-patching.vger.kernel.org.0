Return-Path: <live-patching+bounces-2345-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8F0uBrgw3mnxogkAu9opvQ
	(envelope-from <live-patching+bounces-2345-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 14:19:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6369A3F9EEE
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 14:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7BA37305854C
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 12:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A86E3E1203;
	Tue, 14 Apr 2026 12:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fxl4I8ZH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F1A39B486
	for <live-patching@vger.kernel.org>; Tue, 14 Apr 2026 12:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776168787; cv=none; b=jMZVPURec25GbFUI2aR9+sQ7GMAUznpEe7k1wGhy6KPsiHHlOCspRiuBICE5pZXKIZyjU/zT5T690nxPabIewJvYqm3t3ZakZmsx12CHGokxiiv6pEfY8EBzu8LSPitXIr2TOxoYZlb6PEgXV6F7X+u1pBoRaUW5l/l9jW6lLgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776168787; c=relaxed/simple;
	bh=+QnCQVCjojEcuevSC8g0MJA/h24xDP0xiW/QNvX/aco=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZQWygwdRLI677opVrYvIIHmnALEQqpEsLcKlXfkyFGZioDb8azWsh0R2Iepw9qpdbMFVuUvg0Xr0Gd55Wh4zyybZxbTKrv2od+1Zs4as5RVue2CRZI6+7UfeAevrgnrXhaeVXOTkMp7xaN0us5Aq/lcqGXPDJizybT4qKxYXpko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fxl4I8ZH; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b00ed86fso57190155e9.3
        for <live-patching@vger.kernel.org>; Tue, 14 Apr 2026 05:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776168785; x=1776773585; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+QnCQVCjojEcuevSC8g0MJA/h24xDP0xiW/QNvX/aco=;
        b=fxl4I8ZHiJKWOX/0KlNsMjhxexf+MCO11K7GYjL94X6qgWenvd1KPnp2wxIGGW3ASk
         +3YZmm9S/Le8SrJs7f4USqFGN5wygMj8ZQ66ByZZcUCmq46MmMAl54w8SKxdQU7cWwG7
         5wfxFEU9SP3idSHXctmJ4apkGy4UDAGHLblfQn1Qqw5dHTWiru+el1GNTXbXxSYDIQCC
         LGKnRuzCpWaZ4C14CCDxSs8E/9tE+lowrE+2lu3Ho81Z4qUPsK5CZ7AXsea6DvHhRj6s
         c8MnYGhxnkBtdT3rIIFRVSdawvb40jZhqPukhwhoCncDtwwb1fJiYtUYLHV1HgCcZh1a
         P3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776168785; x=1776773585;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+QnCQVCjojEcuevSC8g0MJA/h24xDP0xiW/QNvX/aco=;
        b=sL1lML1qQRHbxrwwymB90yI+qB/VQVtjVAAMafu0j0hZU63py2c1bayOBckeH0VImN
         hbCpct3Ic0qTnmGGcbQSVH6EkIiqaHpW3ow8MKhkeDXpB7vFeXo0QpXKCZmZ0kclw/Ss
         ueRlGslJeMXJ8DHyHVmZOsjIpkFtaJ2pQjDM+LzEtAiJsUxgHjA4DUMHzzW34/sQ2dQe
         QiabYQWcNfY1Qvz6+iIGXkVCApadxVs+HiT+YcwyfJBPfKAQ/5+lRE4EsVJoMLj3aKV7
         AW60DkkmyMYK8ZZDf2IR94j+kXm/rhChpWqBKTXfKCw72oVayUSYP69Bdahi7M0Ifezc
         h/LQ==
X-Gm-Message-State: AOJu0Yzn6ATCpO2ybtXFYLU6+eVbxD/Akgd/mIJ7JYApQ9SpN4pF5teq
	e0ZnwYTwr5/YXdRG9t+aXEL0yluE8Iggg65uY8+5j3Dy7s5Rg0yOJjNcHRR39xPYVNQ=
X-Gm-Gg: AeBDieuyal3IUXGpXUEXS+VDg/IgxyBEer5Q2FmUQYJ8wX8dDO4DaPD66D4IP5fsQJ7
	22zknw2whQg8S9KhXrp4o9KYcwspa5umO0wjcoimdwM1Mzcuoo5CBdVdGIm236MpVIUdBHMnS+z
	Q7XdnUoCdgN/3vjtKahxMra1Dk1CZ7uafRHpA4s9DqyDdkCDq56sEb44+dp+iVfnquyocVMmXYu
	uq42F55Yc3x3YmoBsu3YE/ki72O8Tt7toL31Oxrjz2P7OzOSkt89ZsIpQLKB9ZjPwuN7mzYsHgW
	dJpyynT8rU5U+S3jzOtWAjmcDxJdsLfYBKceb4VAkSJqN5ki7zws/GLb956aidWyvvYBkyi0d1w
	OspjDRFTGe0D0FnOOFW+kTvvExMN0pAXi5oB0ngBiA3CB3OY8P50jSj0bLtzyEzsT2xvaSFRg0r
	b2az+SPdyfiwA50OOZHsYI8r6VAUjv5hOjzCgK5RX83h/QV0O96M78zzxHgcPMWwVc0wKbiwVm5
	N4KOw==
X-Received: by 2002:a05:600d:8449:b0:486:fdba:f5db with SMTP id 5b1f17b1804b1-488d664f29emr192886925e9.0.1776168784711;
        Tue, 14 Apr 2026 05:13:04 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d67b4a46sm269592205e9.4.2026.04.14.05.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 05:13:04 -0700 (PDT)
Message-ID: <6ab30eed1165bcd68395e32d8ab61d7437a8ccf6.camel@suse.com>
Subject: Re: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be
 executed on 4.12 kernels
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes
	 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
	 <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2026 09:12:58 -0300
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (by Flathub.org) 
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
	TAGGED_FROM(0.00)[bounces-2345-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,msgid.link:url,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: 6369A3F9EEE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 2026-04-13 at 14:26 -0300, Marcos Paulo de Souza wrote:
> A new version of the patchset, with fewer patches now. Please take a
> look!
>=20
> Original cover-letter:
> These patches don't really change how the patches are run, just skip
> some tests on kernels that don't support a feature (like kprobe and
> livepatched living together) or when a livepatch sysfs attribute is
> missing.
>=20
> The last patch slightly adjusts check_result function to skip dmesg
> messages on SLE kernels when a livepatch is removed.
>=20
> These patches are based on printk/for-next branch.
>=20
> Please review! Thanks!
>=20
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>


I saw some checks made by sashiko, and besides they not being so
horrible, I believe that I should fix me an send a v3 to address them.
But still, feel free to take a look :)

https://sashiko.dev/#/patchset/20260413-lp-tests-old-fixes-v2-0-367c7cb5006=
f%40suse.com

> ---
> Changes in v2:
> - Patch descriptions were changed to remove "test-X", since it was
> polluting the commit subjects (Miroslav Benes)
> - Patch 8 was dropped since it was checking for a message from an
> out-of-tree patch. (Petr Mladek)
> - Patch 3 was dropped as should be treated as expected failure for
> older kernels. (Petr Mladek)
> - Patch 2 was changed to use y/n instead of 1/0, since it's more
> natural to use it.
> - Patch 1 was changed to handle ppc and loongson, and error out if
> dealing with a different architecture that sets
> =C2=A0 CONFIG_ARCH_HAS_SYSCALL_WRAPPER and haven't changed the test to
> include the proper wrapper prefix.
> - Patch 4 was changed to invert the return of the bash function to
> return 1 in failure, like
> =C2=A0 a normal bash function (Joe Lawrence)
> - Patches 5, 6 an 7 were changed to not split the tests, but to only
> run the tests
> =C2=A0 when the attribute were present (Miroslav Benes)
> - Link to v1:
> https://patch.msgid.link/20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@su=
se.com
>=20
> ---
> Marcos Paulo de Souza (6):
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: Check for ARCH_HAS_S=
YSCALL_WRAPPER config
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: Replace true/false m=
odule parameter by
> y/n
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: Introduce does_sysfs=
_exists function
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: Check if patched sys=
fs attribute exists
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: Check if replace sys=
fs attribute exists
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: Check if stack_order=
 sysfs attribute
> exists
>=20
> =C2=A0tools/testing/selftests/livepatch/functions.sh=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 10 ++
> =C2=A0tools/testing/selftests/livepatch/test-kprobe.sh=C2=A0=C2=A0 |=C2=
=A0=C2=A0 8 +-
> =C2=A0tools/testing/selftests/livepatch/test-sysfs.sh=C2=A0=C2=A0=C2=A0 |=
 120
> ++++++++++++---------
> =C2=A0.../livepatch/test_modules/test_klp_syscall.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 17 ++-
> =C2=A04 files changed, 99 insertions(+), 56 deletions(-)
> ---
> base-commit: 712c0756828becbfc629ff8d8b82deff5d1115e4
> change-id: 20260309-lp-tests-old-fixes-f955abc8ec27
>=20
> Best regards,
> --=C2=A0=20
> Marcos Paulo de Souza <mpdesouza@suse.com>

