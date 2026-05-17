Return-Path: <live-patching+bounces-2840-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABjKMRggCmrkwwQAu9opvQ
	(envelope-from <live-patching+bounces-2840-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 17 May 2026 22:07:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F62F563AE0
	for <lists+live-patching@lfdr.de>; Sun, 17 May 2026 22:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB26130221C8
	for <lists+live-patching@lfdr.de>; Sun, 17 May 2026 20:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08CF30C153;
	Sun, 17 May 2026 20:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="VqiN0f23"
X-Original-To: live-patching@vger.kernel.org
Received: from sonic303-52.consmr.mail.gq1.yahoo.com (sonic303-52.consmr.mail.gq1.yahoo.com [98.137.64.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0EE2F28EA
	for <live-patching@vger.kernel.org>; Sun, 17 May 2026 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.64.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779048252; cv=none; b=tTItXOTM1IDYu1VXElatf+aVjSs8RiUBSqQr0ZcAI+EovGwmWjrYj+BNPc5NuWXQIMq8d4vOeEC2/v5wviPxQ2W7k9L9guNplT9nHfSZVv+GOB8X9Yyzm+H5eOT7AZ3g/kfdJK5JXnGfIbpkEgmRyebhW7v2x6pKCeDN/s48kRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779048252; c=relaxed/simple;
	bh=MmLVFbUD/lYnBw5Cv1Lp/iLSdOUBUkCMl6UJpMbVYtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WgKwrIc1dG1vpH0ZC96ZUfLZtSl1R5OjSeTgI4yyo/DDd6sRnL9b9uSHe/ibrp+LSPjhNMkDaNpsd9Yzglm+LRyNVMozqIzZyAC41HZe5ewNqOtz7S7qDsPi3lJ9nsD3gB7gUxL9/a3QL6WURajCzC2C1j9HfJ4KL+KW75ExHg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=VqiN0f23; arc=none smtp.client-ip=98.137.64.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1779048248; bh=pjPNPmffDrrDciWSnN1VRX4FQdbTYeVFcwtoroOKnVw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=VqiN0f2314V+dBjPZtgWY6ytzOGZV1xYMhkJkb10QxF8RmUKvZXvEkky7ZY5qm8Y+9jtFYygw7+TbcpQ1bz6Y2hQ2a4Af/wOedTdqOjA4bJa8DxCivG1eO9bXBN1BdTFfi7ADB9S4m4WXVcOwzBZzWzcYNpmO9xb3ux1F8zGMGnsat4borGZCLk9aoUV2bp4tDxNXjLiwaiaSanNT9W3AfaR384Qr0QLEE3mTFdd2Mz6PGTS8NF4O3TY9iUV8BqzaF+xt/rrqAaISDaH1DAduerKuUixBRzI9L1aB76nr9Fzo8vu4UuHq9lEOM6v0rFN5ZA/vcpaPvYyz7vhxX707A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1779048248; bh=v3gJr4rhNfGuS/8icGAVlIv3KEPZhPVYZsTLz6muo8i=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=fDksujNkkNve12HI/sxEjxNuIyGDkFxpSqufybbs0XtXFnwHBKWtKKz2hfG0VUZaSpgp5/LPo2D1C59bxRzHp48pZnEKpIKcxO3VuLYBJpdTlHugex7YGjr2Ge8ax19In6ckugFIbiJlZb70Y7miu3Xfg4GkvD36Y6eUy6VPwXeofa2qqY2s34i6F1GEhgXp9M0yB0lM9e2hCqIsefcrl/fj0Yyfd6hFd4R2Unl9wwxu02L9iwaChcEKJ3tXX0eYnVqZQDNSZdgLEaywTkokj16KTVn0D11Yovq72j47wYLUWTEnVJXtp8BGXimgmIr2uBbciqrYUpFQW+DOmCT5Fg==
X-YMail-OSG: HGVmEl4VM1mCRx5tFiQRmxXrW8bzryPqirv1oVRwLh1_5IJb1SJoz0u9Y1x_JWN
 NYvl4HkNhc5KEJmeMj0MZLju4YT2bZoRZjdkKQ9GGrhtjxSQ5Q159zGX7APOQm7zSbnb9nisQXL8
 5LCdj2n389UGbotf2dww5l13ZVP8Pm5hnzn.lkt18fKx4qmO6om3lUEZUimYr2wZaco6aF5sk2aU
 FCJkUDYvhmyy0C8FAuD8yZFLOaEF_KbDjdkIekt_2uTNsOCDLZp_mFwWI0RlhVXdXrttDB0b4cX_
 qh7jkju2B3ngA42DJAv_ElImQhCfYeIV_Ze2wy1dZltxIxyJoVrDQYE5m_MtPAcNakKlnCfdpfFk
 tyN5BAyXBT1PNdmH_0zvQ.sINzKz3tM1OdCZMTbBRxWofGIFgVFgNUgaQsQXoT.bV1WiuQgGuPf1
 PbvMvOz.IQkMBniXcOUxgfPooPx9K1PLbSG1QBXhj3cSvzM311DbpBiL685auM4FVVB69gPc9JD7
 e8ljUPtlXnzd.oWjWCevQDVA6s4pTz9Yc9UhwZmWJqxpfvLXRk.01nZKCwI8ha3qo.2_noFM8tTF
 rjEvwEwRHZcYyDCV7rpFHkczHvX3VfzPxvG7Rk2Yas8_2g0qEydYHAujRF0U7aKeZMzg5NTrsfNe
 m2h_dmcoq.v9yZiaWrI7h0a_xFc7rd67JvvLGlBD3icI3cLNUkTCdfc2MaHP5.Z8IaRz6QfpcgKh
 PRjnIDkOvqQe_avP8a9m2TBDcqoGyf7hpghV793DYd_lVy4e8WOHp6QqRvNMeeC3smmLHBzwk5DI
 hM6GxLP0wimUeHCt5YOAu_HTXUpXYzmcLlVz1Gg8OSoybsZ3kNzb5iEGg9vL_Qi_T5q3erdDaaAX
 PXOPver3qm890hSjgjmJ9G5EOq7IAWV30uFqDFM8a9fgEHgMXWEifmeLwsCxiaeD6uqOhAGHjteh
 0ukOzhP9BWWaJrf50govCE2V2X2FIBAyjuIjwL_y91sJBBoZlEPrnDvHR3dFzuqhAn0ATJ_Vfr1z
 iJ77LlDsiUr2rjRRb35v32YW92z3F.10B0k67IHC3cfStZEVxAoRdBkUicsxCDtrSsIHV6hFiVkf
 VYNStsaDqcTKpdFoxxIadL2Bn6ZsxV3gjIUVbvKcw21xgaQC7LT3_8gclacUMGhGUz6IkT0qYzkS
 ._8h5Qp.C4Rw5d9dSTHe3wEUav1bcDuIcDqq9TF6BWKTVzNvZlbTmH8vIk3ckMqhN4di5rPOIAA1
 Y_fORmHOSaH0PH8bHVhRkrC2xBexmD3srlSwNcBnNM4euAsph2p7GLnC9e2SFrkNyez7ASS3assE
 axF5ESj_qK81u9N5_Fupx0JzpAGPNOGFLoyHAMPkTmkGIBvch3gx98boCiIq1svVY0mueYCnFGnq
 E6v3PpwB.S_jYfseDLKELIo.H4VjRAwQk4U9UlmjWmYi7947o7E28Z.d2zkVuJ2kpu89yD.vGARZ
 h8lvt2phjTWMfHX3_ZWGl1mADuBtJBOCJ4ElvfsD_WYxGEej1n8QyctE9SQfhkWmdQG7BkEBsyiy
 vucxhsg5.A8eppR5dEboiy4w9h.YUlRPIppVZNj1f5W7TODg6yrFwJIyjTx_7JKd86xYJqboTaUB
 IeX8DUcR0onBHYEmN9tMPnLpJlt5qsa.Y_4vFnMDQ9HsWBKD1L.7Yn5zu8ptGEBC0WRQ.KEfoEl4
 M3X4R6c_wISmDjUH7HVYDEblLz0N9U0uVGdFoX3la98FLEqZOwKCs3fy9LjX3tiHMZWdkRByJJxy
 7fc4X6fPUhNmQwIFiXdplppJjAMn8Is4K1CIzOqJFa6_wbhKtIL1j8Bcr7zQU2P4y2QXM2SvfEPu
 un0MrTpmNMf9dYw2.rgZcdUd.O3GWOVCHS..54IVczeDrnktoyX1oQ2lF1Qkg74fZLfZMtVKJ23F
 uAtPHGT_1NJW4D1SLM11P5TbucF69E.PMD_kHbafFf8cbhO5._stvp0uYur5aHerV8P2_0fgDA8T
 tjJ4rLIP8Dfsfoy_n7vB44OS3ukGY1Y23xuA85UqBd2yruL2cCKNIcVBHR.bGuibvxc3yIQTW3KE
 NxEKoEbZUcixKnAXkbBtzSSVqt9EkbcaeG8yqkZQ.C0zWU6kroA_0BXHv.9zJsi1G.9zOderWFfx
 gkPMWoi6A2zP3CS9Iqlg5si2ZeO75gfDtnsh39yLReP5vT1ZX3SPPR_N3mBrTMIDrPq2sgoIdygl
 uHs17V6ZDy_PaQjmYpOZtsvB6M0Eb.nKu46gRRXYqIsOQ6oLA5TJYlKM_I9ZVdcTnUZPLR686tqL
 jfT3MRpKDtpI0ZOaF
X-Sonic-MF: <bt610490@yahoo.com>
X-Sonic-ID: f42f9061-7205-47fa-9378-687b72c33a83
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.gq1.yahoo.com with HTTP; Sun, 17 May 2026 20:04:08 +0000
Received: by hermes--production-ne1-57485d68c4-xkxlc (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 061e3341ad253ffbce96eed418f69d88;
          Sun, 17 May 2026 19:19:38 +0000 (UTC)
Message-ID: <e4527b42-f2e6-447a-861d-580a521bde19@yahoo.com>
Date: Sun, 17 May 2026 14:19:35 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation
 primitive
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 bpf@vger.kernel.org, live-patching@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Joshua Peisach <jpeisach@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>,
 Breno Leitao <leitao@debian.org>, Anthony Iliopoulos <ailiop@suse.com>,
 Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
Content-Language: en-US
From: Brandon Taylor <bt610490@yahoo.com>
In-Reply-To: <20260517134858.146569-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.25725 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Rspamd-Queue-Id: 2F62F563AE0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[yahoo.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[yahoo.com:s=s2048];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2840-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[yahoo.com:+];
	FREEMAIL_FROM(0.00)[yahoo.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bt610490@yahoo.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[davemloft.net:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Have we learned NOTHING from just over 9 and a half years ago?!

I do not pretend to be a prophet of Linus, but I cannot for the life of 
me help but get flashbacks from kernel version 4.8 when Linus himself 
did not explain, but EXPLODED, in saying "there is NO F*CKING EXCUSE to 
knowingly kill the kernel."

So for me to hear about THIS from a YouTube video, the fact that we are 
still--STILL!--coming up with new ways to do something which we ought to 
KNOW to be ABSOLUTELY UNACCEPTABLE and DOWNRIGHT INTOLERABLE, BOILS MY 
BLOOD TO NO END.

You ought to consider yourself lucky that it's ME writing this and not 
Linus, because he'd be saying the exact same thing, and making it God 
knows how many times worse. He would break his foot off in somebody's 
BEHIND over this "killswitch" idiocy, and NEVER MIND that it was 
supposedly "designed" to prevent exploits like Fragnesia, Copy Fail, and 
Dirty Frag from creating havoc in Linux distributions, ESPECIALLY his 
go-to in Fedora!

Forgive me (especially you, Master Linus) for blowing my stack over 
this, but we all ought to take a lesson from the past:

Killing the Linux kernel is NOT an acceptable method to mitigate exploits.

I don't care HOW long it takes, but we HAVE TO PATCH THOSE 
VULNERABILITIES, and we HAVE to do it the RIGHT WAY, NOT just introduce 
some kernel-killing "failsafe" just because somebody doesn't know how to 
plug those holes.

I don't care--and neither will Linus--about the so-called "simplest 
mitigation," and neither should you. We should all care that we get the 
code RIGHT.

Brandon

On 5/17/2026 8:48 AM, Sasha Levin wrote:
> When a kernel (security) issue goes public, fleets stay exposed until a patched
> kernel is built, distributed, and rebooted into.
>
> For many such issues the simplest mitigation is to stop calling the buggy
> function. Killswitch provides that. An admin writes:
>
>      echo "engage af_alg_sendmsg -1" \
>          > /sys/kernel/security/killswitch/control
>
> After this, af_alg_sendmsg() returns -EPERM on every call without
> running its body. The mitigation takes effect immediately, and is dropped on
> the next reboot -- by which point a patched kernel is hopefully in place.
>
> A lot of recent kernel issues sit in code paths most installs only have enabled
> to support a relative minority of users: AF_ALG, ksmbd, nf_tables, vsock, ax25,
> and friends.
>
> For most users, the cost of "this socket family stops working for the day" is
> much smaller than the cost of running a known vulnerable kernel until the fix
> lands.
>
> Why not an existing facility:
>
> * livepatch needs a built, signed, per-kernel-version module per CVE.
>    Under Secure Boot the operator can't sign their own, so they wait
>    for the vendor, and only a minority of vendors actually ship
>    livepatches. Killswitch covers the days before that module shows
>    up.
>
> * fail_function (CONFIG_FUNCTION_ERROR_INJECTION) is disabled in
>    most production kernels. Even where enabled, it only works on
>    functions pre-annotated with ALLOW_ERROR_INJECTION() in source -
>    no help for a freshly-disclosed CVE. The debugfs UI is blocked by
>    lockdown=integrity and the override is probabilistic.
>
> * BPF override (bpf_override_return) honors the same
>    ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
>    production kernels. Even where on, the operator interface is
>    "load a verified BPF program," not a one-line write.
>
> * Module blacklist only helps when the bug is in a loadable module.
>
> Killswitch fills the gap: write a symbol to securityfs, function
> returns the chosen value until disengage or reboot.
>
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> Changes since v2:
> - Fix LLVM=1 build: gate __noipa__ on __has_attribute() (Breno)
> - Admin guide: do-not-engage list, pre-soak workflow, relation to
>    livepatch/fail_function/BPF (Michal, Mathieu, Joshua)
> - Add CVE-2026-43284 (esp_input) worked example + netns selftest
> - Drop unused [reason] token from Kconfig help and cmdline comment
> - Commit message: spell out why livepatch / fail_function / BPF
>    override / module-blacklist don't cover this window.
>
>   Documentation/admin-guide/index.rst           |   1 +
>   Documentation/admin-guide/killswitch.rst      | 229 +++++
>   Documentation/admin-guide/tainted-kernels.rst |   8 +
>   MAINTAINERS                                   |  11 +
>   include/linux/killswitch.h                    |  19 +
>   include/linux/panic.h                         |   3 +-
>   include/linux/security.h                      |   1 +
>   init/Kconfig                                  |   2 +
>   kernel/Kconfig.killswitch                     |  31 +
>   kernel/Makefile                               |   1 +
>   kernel/killswitch.c                           | 863 ++++++++++++++++++
>   kernel/panic.c                                |   1 +
>   lib/Kconfig.debug                             |  13 +
>   lib/Makefile                                  |   1 +
>   lib/test_killswitch.c                         |  85 ++
>   security/security.c                           |   1 +
>   tools/testing/selftests/Makefile              |   1 +
>   tools/testing/selftests/killswitch/.gitignore |   1 +
>   tools/testing/selftests/killswitch/Makefile   |   8 +
>   .../selftests/killswitch/cve_31431_test.c     | 162 ++++
>   .../selftests/killswitch/cve_43284_test.c     |  88 ++
>   .../selftests/killswitch/killswitch_test.sh   | 254 ++++++
>   22 files changed, 1783 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/admin-guide/killswitch.rst
>   create mode 100644 include/linux/killswitch.h
>   create mode 100644 kernel/Kconfig.killswitch
>   create mode 100644 kernel/killswitch.c
>   create mode 100644 lib/test_killswitch.c
>   create mode 100644 tools/testing/selftests/killswitch/.gitignore
>   create mode 100644 tools/testing/selftests/killswitch/Makefile
>   create mode 100644 tools/testing/selftests/killswitch/cve_31431_test.c
>   create mode 100644 tools/testing/selftests/killswitch/cve_43284_test.c
>   create mode 100755 tools/testing/selftests/killswitch/killswitch_test.sh
>
> diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
> index cd28dfe91b060..ca37dd70f108d 100644
> --- a/Documentation/admin-guide/index.rst
> +++ b/Documentation/admin-guide/index.rst
> @@ -70,6 +70,7 @@ problems and bugs in particular.
>      bug-hunting
>      bug-bisect
>      tainted-kernels
> +   killswitch
>      ramoops
>      dynamic-debug-howto
>      init
> diff --git a/Documentation/admin-guide/killswitch.rst b/Documentation/admin-guide/killswitch.rst
> new file mode 100644
> index 0000000000000..a524cc9ee23ca
> --- /dev/null
> +++ b/Documentation/admin-guide/killswitch.rst
> @@ -0,0 +1,229 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +..
> +.. Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> +
> +============
> +Killswitch
> +============
> +
> +Killswitch lets a privileged operator make a chosen kernel function
> +return a fixed value without executing its body, as a temporary
> +mitigation for a security bug while a real fix is being prepared.
> +
> +The function returns the operator-supplied value and nothing else
> +runs in its place. There is no allowlist, no return-type check; if
> +the kprobe layer accepts the symbol, killswitch engages it. Once
> +engaged, the change is in effect on every CPU until ``disengage`` is
> +written or the system reboots.
> +
> +Configuration
> +=============
> +
> +``CONFIG_KILLSWITCH``
> +  Enables the feature. Depends on ``SECURITYFS``, ``KPROBES`` (with
> +  ftrace support), and ``FUNCTION_ERROR_INJECTION``.
> +
> +The interface
> +=============
> +
> +::
> +
> +    /sys/kernel/security/killswitch/
> +        engaged                 RO  currently-engaged functions
> +        control                 WO  command sink
> +        taint                   RO  0 or 1
> +        fn/<name>/              per-function directory, created on engage
> +            retval              RW  return value
> +            hits                RO  per-cpu summed call count
> +
> +Three commands are accepted by ``control``::
> +
> +    engage <symbol> <retval>
> +    disengage <symbol>
> +    disengage_all
> +
> +Each engage and disengage emits a single ``KERN_WARNING`` line to
> +dmesg with the symbol, retval, hit count (on disengage), and the
> +operator's identity (uid/auid/sessionid/comm, or ``source=cmdline``).
> +
> +Engagement is rejected when:
> +
> +* the symbol is unknown, in a non-traceable section, on the kprobe
> +  blacklist, or otherwise refused by ``register_kprobe`` (the error
> +  from the kprobe layer is logged and returned to userspace);
> +* the symbol is already engaged (``-EBUSY``);
> +* the operator does not hold ``CAP_SYS_ADMIN``.
> +
> +Whatever value the operator writes is what the function returns.
> +Writing the wrong type or wrong value lands in the caller as-is.
> +
> +Boot parameter
> +==============
> +
> +``killswitch=fn1=<val>,fn2=<val>,...``
> +
> +Parsed early; engagements are applied at the end of kernel init
> +once the kprobe subsystem is up. Parse failures emit a warning and
> +skip the offending entry; they never panic.
> +
> +Useful for fleet rollout: when an issue drops, ship the mitigation
> +in the bootloader / PXE config and roll the fleet through reboots
> +while the real fix is being prepared.
> +
> +Tainting
> +========
> +
> +The first successful engagement (runtime or boot-time) sets
> +``TAINT_KILLSWITCH`` (bit 20, char ``H``). The taint persists across
> +``disengage`` until reboot, so an oops on a killswitch-modified
> +kernel is identifiable from the banner: ``Tainted: ... H`` tells a
> +maintainer to consult ``engaged`` before further triage.
> +
> +Module unload
> +=============
> +
> +If a module containing an engaged target is unloaded, killswitch
> +auto-disengages the entry and emits a ``KERN_WARNING`` so the loss
> +of mitigation is visible. Reloading the module does not silently
> +re-arm the killswitch; the operator re-engages explicitly.
> +
> +Choosing the right target
> +=========================
> +
> +A function that *looks* skippable may be relied on by callers for a
> +side effect (a lock the caller releases, a refcount the caller
> +drops, a scatterlist the caller consumes). The rule of thumb:
> +
> +  Pick the **highest-level** entry point that contains the bug.
> +
> +That gives callers no chance to dereference half-initialised state
> +from a function whose body was skipped. Two illustrative examples
> +from ``crypto/af_alg.c``:
> +
> +Anti-pattern: ``af_alg_count_tsgl``
> +-----------------------------------
> +
> +``af_alg_count_tsgl()`` returns ``unsigned int`` (the number of TX
> +SG entries). Engaging it with retval ``0`` causes the caller in
> +``algif_aead.c`` to allocate a 1-entry scatterlist (its
> +``if (!entries) entries = 1`` guard) and then walk the *real* TX
> +SGL into that undersized destination via ``af_alg_pull_tsgl``,
> +producing out-of-bounds writes. **Killswitching here introduces a
> +worse bug than the one being mitigated.**
> +
> +Anti-pattern: ``af_alg_pull_tsgl``
> +----------------------------------
> +
> +``af_alg_pull_tsgl()`` returns ``void``, so any retval is accepted.
> +But its caller depends on the per-request SGL being filled in.
> +Skipping the body leaves the per-request SGL with NULL pages; the
> +next-stage ``memcpy_sglist`` dereferences them and the kernel
> +oopses.
> +
> +Correct pattern: ``af_alg_sendmsg``
> +-----------------------------------
> +
> +``af_alg_sendmsg()`` is the highest-level entry into the AF_ALG
> +send path. Engaging it with retval ``-EPERM`` causes every send
> +attempt to return -EPERM to userspace; no caller ever sees
> +half-initialised state, and any AF_ALG-reachable bug downstream of
> +``sendmsg`` is unreachable until the killswitch is disengaged.
> +
> +The canonical pattern: pick a syscall-handler-shaped function whose
> +return value already encodes "this operation didn't happen", and
> +let userspace handle the error as it would any other failed
> +syscall.
> +
> +Correct pattern: ``esp_input`` (CVE-2026-43284)
> +-----------------------------------------------
> +
> +The IPsec ESP receive-path bug fixed by ``xfrm: esp: avoid in-place
> +decrypt on shared skb frags`` is reachable through ``esp_input()``
> +in ``net/ipv4/esp4.c`` (and ``esp6_input()`` for IPv6). Engage these
> +with retval ``-EINVAL``:
> +
> +::
> +
> +    echo "engage esp_input -22"  > /sys/kernel/security/killswitch/control
> +    echo "engage esp6_input -22" > /sys/kernel/security/killswitch/control
> +
> +Inbound ESP packets are then dropped before decapsulation, neutering
> +any bug downstream of the ESP receive path. IPsec tunnels stop
> +working; other networking is unaffected.
> +
> +Do not engage
> +=============
> +
> +Do not killswitch:
> +
> +* process or memory primitives the rest of the kernel needs to
> +  function: ``fork``, ``do_exit``, ``__alloc_pages``, ``kmalloc``,
> +  ``schedule``, anything in ``mm/`` reached by every allocation.
> +* hot paths in the scheduler, timekeeping, RCU, or interrupt entry.
> +* functions invoked from the killswitch path itself (``securityfs``,
> +  ``lockdown``, ``audit``, ``kprobe`` registration) -- the system
> +  may livelock or refuse to disengage.
> +* functions whose return value is read structurally (size, count,
> +  pointer-to-allocated-thing) rather than as success/failure.
> +  See the AF_ALG anti-patterns above for what goes wrong.
> +
> +When in doubt, measure first.
> +
> +Pre-soak before engaging
> +========================
> +
> +If the target's call rate is unknown, attach a counter for a few
> +seconds first. With perf::
> +
> +    perf probe --add 'esp_input'
> +    perf stat -a -e probe:esp_input -- sleep 5
> +
> +Or with bpftrace::
> +
> +    bpftrace -e 'kprobe:esp_input { @hits = count(); } interval:s:5 { exit(); }'
> +
> +A target with ten thousand hits per second is not a candidate -- the
> +kernel will not survive five seconds with that path returning a
> +fixed error.
> +
> +Relation to other facilities
> +============================
> +
> +* ``CONFIG_FUNCTION_ERROR_INJECTION`` provides the same architecture
> +  trampoline (``override_function_with_return``), which killswitch
> +  reuses. fail_function is debug-oriented: targets must be
> +  pre-annotated with ``ALLOW_ERROR_INJECTION()`` in source, the
> +  override is probabilistic, and the interface is on debugfs (blocked
> +  under ``lockdown=integrity``). Killswitch is the production cousin:
> +  no whitelist, deterministic, securityfs-visible under integrity
> +  lockdown, with audit and taint.
> +* livepatch can do everything killswitch can and more, at the cost
> +  of building, signing, and shipping a kernel module per mitigation.
> +  Killswitch is for the window before that module exists.
> +* BPF override (``bpf_override_return``) needs a BPF program and
> +  ``CONFIG_BPF_KPROBE_OVERRIDE``; appropriate when the policy is
> +  conditional, overkill for "always return -EPERM".
> +
> +Safety notes
> +============
> +
> +* In-flight calls during ``write()`` to ``control`` may run either
> +  the original body or the override. The override is ``return X``,
> +  which has no preconditions to violate.
> +* SMP visibility comes from ``text_poke_bp()``. ``write()`` to
> +  ``control`` returns only after every CPU sees the new path.
> +* The ftrace ops unregister waits for in-flight pre-handlers, so
> +  freeing the engagement attribute on disengage is safe.
> +* Inline functions, freed ``__init`` symbols, and anything compiled
> +  away cannot be killswitched. ``register_kprobe`` rejects them
> +  with whatever error the kprobe layer chooses.
> +
> +Diagnostics
> +===========
> +
> +Per-call hits are aggregated in a per-cpu counter readable at
> +``/sys/kernel/security/killswitch/fn/<name>/hits``. Per-hit logging
> +is not provided to avoid log storms on hot paths.
> +
> +A ``KILLSWITCH`` entry appears in the kernel taint vector once any
> +engagement succeeds (also visible as ``H`` in the oops banner).
> diff --git a/Documentation/admin-guide/tainted-kernels.rst b/Documentation/admin-guide/tainted-kernels.rst
> index 9ead927a37c0f..71a6e3364eddc 100644
> --- a/Documentation/admin-guide/tainted-kernels.rst
> +++ b/Documentation/admin-guide/tainted-kernels.rst
> @@ -102,6 +102,7 @@ Bit  Log  Number  Reason that got the kernel tainted
>    17  _/T  131072  kernel was built with the struct randomization plugin
>    18  _/N  262144  an in-kernel test has been run
>    19  _/J  524288  userspace used a mutating debug operation in fwctl
> + 20  _/H 1048576  killswitch override engaged (function short-circuited)
>   ===  ===  ======  ========================================================
>   
>   Note: The character ``_`` is representing a blank in this table to make reading
> @@ -189,3 +190,10 @@ More detailed explanation for tainting
>    19) ``J`` if userspace opened /dev/fwctl/* and performed a FWTCL_RPC_DEBUG_WRITE
>        to use the devices debugging features. Device debugging features could
>        cause the device to malfunction in undefined ways.
> +
> + 20) ``H`` if the killswitch primitive (see
> +     Documentation/admin-guide/killswitch.rst) has been engaged on at least
> +     one function. The kernel is no longer running its source: at least one
> +     function has been short-circuited to return a fixed value. The taint
> +     persists across ``disengage`` until the next reboot — once the running
> +     image has been modified, oops triage must reflect that.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2040011a3865..b4005b61d444f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14350,6 +14350,17 @@ F:	lib/Kconfig.kmsan
>   F:	mm/kmsan/
>   F:	scripts/Makefile.kmsan
>   
> +KILLSWITCH (function short-circuit mitigation)
> +M:	Sasha Levin <sashal@kernel.org>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/admin-guide/killswitch.rst
> +F:	include/linux/killswitch.h
> +F:	kernel/Kconfig.killswitch
> +F:	kernel/killswitch.c
> +F:	lib/test_killswitch.c
> +F:	tools/testing/selftests/killswitch/
> +
>   KPROBES
>   M:	Naveen N Rao <naveen@kernel.org>
>   M:	"David S. Miller" <davem@davemloft.net>
> diff --git a/include/linux/killswitch.h b/include/linux/killswitch.h
> new file mode 100644
> index 0000000000000..3fad49e180ddf
> --- /dev/null
> +++ b/include/linux/killswitch.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> + */
> +#ifndef _LINUX_KILLSWITCH_H
> +#define _LINUX_KILLSWITCH_H
> +
> +#ifdef CONFIG_KILLSWITCH
> +int killswitch_engage(const char *symbol, long retval);
> +int killswitch_disengage(const char *symbol);
> +bool killswitch_is_engaged(const char *symbol);
> +#else
> +static inline int killswitch_engage(const char *symbol, long retval)
> +{ return -EOPNOTSUPP; }
> +static inline int killswitch_disengage(const char *symbol) { return -EOPNOTSUPP; }
> +static inline bool killswitch_is_engaged(const char *symbol) { return false; }
> +#endif
> +
> +#endif /* _LINUX_KILLSWITCH_H */
> diff --git a/include/linux/panic.h b/include/linux/panic.h
> index f1dd417e54b29..6699261a61f13 100644
> --- a/include/linux/panic.h
> +++ b/include/linux/panic.h
> @@ -88,7 +88,8 @@ static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
>   #define TAINT_RANDSTRUCT		17
>   #define TAINT_TEST			18
>   #define TAINT_FWCTL			19
> -#define TAINT_FLAGS_COUNT		20
> +#define TAINT_KILLSWITCH		20
> +#define TAINT_FLAGS_COUNT		21
>   #define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
>   
>   struct taint_flag {
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 41d7367cf4036..038027c33ba1a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -146,6 +146,7 @@ enum lockdown_reason {
>   	LOCKDOWN_DBG_WRITE_KERNEL,
>   	LOCKDOWN_RTAS_ERROR_INJECTION,
>   	LOCKDOWN_XEN_USER_ACTIONS,
> +	LOCKDOWN_KILLSWITCH,
>   	LOCKDOWN_INTEGRITY_MAX,
>   	LOCKDOWN_KCORE,
>   	LOCKDOWN_KPROBES,
> diff --git a/init/Kconfig b/init/Kconfig
> index 2937c4d308aec..5368dd4b5c65b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2278,6 +2278,8 @@ config ASN1
>   
>   source "kernel/Kconfig.locks"
>   
> +source "kernel/Kconfig.killswitch"
> +
>   config ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>   	bool
>   
> diff --git a/kernel/Kconfig.killswitch b/kernel/Kconfig.killswitch
> new file mode 100644
> index 0000000000000..a33f7ecb2861e
> --- /dev/null
> +++ b/kernel/Kconfig.killswitch
> @@ -0,0 +1,31 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Killswitch: per-function short-circuit mitigation primitive.
> +#
> +# Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> +#
> +
> +config KILLSWITCH
> +	bool "Killswitch: short-circuit a kernel function as a CVE mitigation"
> +	depends on SECURITYFS
> +	depends on KPROBES && HAVE_KPROBES_ON_FTRACE
> +	depends on HAVE_FUNCTION_ERROR_INJECTION
> +	select FUNCTION_ERROR_INJECTION
> +	help
> +	  Provide an admin-facing mechanism to make a chosen kernel function
> +	  return a fixed value without executing its body, as a temporary
> +	  mitigation for a security bug before a real fix is available.
> +
> +	  Operators write "engage <symbol> <retval>" to
> +	  /sys/kernel/security/killswitch/control. The function entry is
> +	  redirected via a kprobe whose pre-handler sets the chosen return
> +	  value and short-circuits the call. There is no allowlist,
> +	  denylist, or return-type validation: if the kprobe layer accepts
> +	  the symbol the engagement proceeds, otherwise its error is
> +	  returned to userspace.
> +
> +	  This is *not* livepatch: there is no replacement implementation,
> +	  the function simply returns the chosen value. Engaging a killswitch
> +	  taints the kernel (TAINT_KILLSWITCH, 'H'). Requires CAP_SYS_ADMIN.
> +
> +	  If unsure, say N.
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 6785982013dce..b3e408d9f275e 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -100,6 +100,7 @@ obj-$(CONFIG_GCOV_KERNEL) += gcov/
>   obj-$(CONFIG_KCOV) += kcov.o
>   obj-$(CONFIG_KPROBES) += kprobes.o
>   obj-$(CONFIG_FAIL_FUNCTION) += fail_function.o
> +obj-$(CONFIG_KILLSWITCH) += killswitch.o
>   obj-$(CONFIG_KGDB) += debug/
>   obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
>   obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
> diff --git a/kernel/killswitch.c b/kernel/killswitch.c
> new file mode 100644
> index 0000000000000..7f509c62ea748
> --- /dev/null
> +++ b/kernel/killswitch.c
> @@ -0,0 +1,863 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Per-function short-circuit mitigation.
> + *
> + * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> + *
> + * Engaging a killswitch installs a kprobe at the function's entry
> + * whose pre-handler sets the return register and skips the body via
> + * override_function_with_return().  Operator interface lives at
> + * /sys/kernel/security/killswitch/.
> + */
> +
> +#include <linux/audit.h>
> +#include <linux/capability.h>
> +#include <linux/cred.h>
> +#include <linux/ctype.h>
> +#include <linux/error-injection.h>
> +#include <linux/init.h>
> +#include <linux/killswitch.h>
> +#include <linux/kprobes.h>
> +#include <linux/kref.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/panic.h>
> +#include <linux/percpu.h>
> +#include <linux/printk.h>
> +#include <linux/sched.h>
> +#include <linux/security.h>
> +#include <linux/seq_file.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/uaccess.h>
> +#include <linux/uidgid.h>
> +
> +struct ks_attr {
> +	struct list_head	list;
> +	struct kprobe		kp;
> +	/* atomic so a writer racing an in-flight call can't tear the long. */
> +	atomic_long_t		retval;
> +	/* false once disengaged; per-fn file ops then return -EIDRM. */
> +	bool			engaged;
> +	unsigned long __percpu	*hits;
> +	struct dentry		*dir;
> +	/* engaged_list holds one ref; each open per-fn fd holds one. */
> +	struct kref		refcnt;
> +};
> +
> +static DEFINE_MUTEX(ks_lock);
> +static LIST_HEAD(ks_engaged_list);
> +static struct dentry *ks_root_dir;
> +static struct dentry *ks_fn_dir;	/* parent for per-fn directories */
> +
> +/* ------------------------------------------------------------------ *
> + * Pre-handler: the actual override                                   *
> + * ------------------------------------------------------------------ */
> +
> +static int ks_kprobe_pre_handler(struct kprobe *kp, struct pt_regs *regs)
> +{
> +	struct ks_attr *attr = container_of(kp, struct ks_attr, kp);
> +
> +	this_cpu_inc(*attr->hits);
> +	regs_set_return_value(regs, (unsigned long)atomic_long_read(&attr->retval));
> +	override_function_with_return(regs);
> +	return 1;
> +}
> +NOKPROBE_SYMBOL(ks_kprobe_pre_handler);
> +
> +/* Defined non-NULL so the kprobe layer keeps the IPMODIFY ops. */
> +static void ks_kprobe_post_handler(struct kprobe *kp, struct pt_regs *regs,
> +				   unsigned long flags)
> +{
> +}
> +
> +/* ------------------------------------------------------------------ *
> + * Attribute lifecycle                                                *
> + * ------------------------------------------------------------------ */
> +
> +static struct ks_attr *ks_attr_lookup(const char *symbol)
> +{
> +	struct ks_attr *attr;
> +
> +	list_for_each_entry(attr, &ks_engaged_list, list)
> +		if (!strcmp(attr->kp.symbol_name, symbol))
> +			return attr;
> +	return NULL;
> +}
> +
> +static unsigned long ks_attr_hits(const struct ks_attr *attr)
> +{
> +	unsigned long total = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		total += *per_cpu_ptr(attr->hits, cpu);
> +	return total;
> +}
> +
> +static void ks_attr_destroy(struct ks_attr *attr)
> +{
> +	if (!attr)
> +		return;
> +	free_percpu(attr->hits);
> +	kfree(attr->kp.symbol_name);
> +	kfree(attr);
> +}
> +
> +static void ks_attr_kref_release(struct kref *kref)
> +{
> +	ks_attr_destroy(container_of(kref, struct ks_attr, refcnt));
> +}
> +
> +static void ks_attr_get(struct ks_attr *attr)
> +{
> +	kref_get(&attr->refcnt);
> +}
> +
> +static void ks_attr_put(struct ks_attr *attr)
> +{
> +	kref_put(&attr->refcnt, ks_attr_kref_release);
> +}
> +
> +static struct ks_attr *ks_attr_alloc(const char *symbol)
> +{
> +	struct ks_attr *attr;
> +
> +	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> +	if (!attr)
> +		return NULL;
> +
> +	attr->kp.symbol_name = kstrdup(symbol, GFP_KERNEL);
> +	if (!attr->kp.symbol_name)
> +		goto err;
> +
> +	attr->hits = alloc_percpu(unsigned long);
> +	if (!attr->hits)
> +		goto err;
> +
> +	attr->kp.pre_handler = ks_kprobe_pre_handler;
> +	attr->kp.post_handler = ks_kprobe_post_handler;
> +	INIT_LIST_HEAD(&attr->list);
> +	kref_init(&attr->refcnt);
> +	return attr;
> +
> +err:
> +	ks_attr_destroy(attr);
> +	return NULL;
> +}
> +
> +/* ------------------------------------------------------------------ *
> + * Securityfs: per-fn attribute files                                 *
> + * ------------------------------------------------------------------ */
> +
> +/*
> + * Look up by symbol name (the parent dentry's basename) under
> + * ks_lock and confirm attr->dir is the file's parent dentry.  This
> + * binds the fd to the engagement it was opened against and avoids
> + * dereferencing inode->i_private, which a racing disengage may have
> + * freed.  d_parent is stable for the open's lifetime via the file's
> + * dentry reference.
> + */
> +static int ks_attr_open(struct inode *inode, struct file *file)
> +{
> +	struct dentry *parent = file->f_path.dentry->d_parent;
> +	const char *name = parent->d_name.name;
> +	struct ks_attr *attr;
> +
> +	mutex_lock(&ks_lock);
> +	attr = ks_attr_lookup(name);
> +	if (attr && attr->dir == parent)
> +		ks_attr_get(attr);
> +	else
> +		attr = NULL;
> +	mutex_unlock(&ks_lock);
> +	if (!attr)
> +		return -ENOENT;
> +	file->private_data = attr;
> +	return 0;
> +}
> +
> +static int ks_attr_release(struct inode *inode, struct file *file)
> +{
> +	ks_attr_put(file->private_data);
> +	file->private_data = NULL;
> +	return 0;
> +}
> +
> +/* Caller must hold ks_lock. */
> +static int ks_attr_check_live(const struct ks_attr *attr)
> +{
> +	return attr->engaged ? 0 : -EIDRM;
> +}
> +
> +static ssize_t ks_retval_read(struct file *file, char __user *ubuf,
> +			      size_t count, loff_t *ppos)
> +{
> +	struct ks_attr *attr = file->private_data;
> +	char buf[32];
> +	long val;
> +	int ret, len;
> +
> +	mutex_lock(&ks_lock);
> +	ret = ks_attr_check_live(attr);
> +	val = atomic_long_read(&attr->retval);
> +	mutex_unlock(&ks_lock);
> +	if (ret)
> +		return ret;
> +	len = scnprintf(buf, sizeof(buf), "%ld\n", val);
> +	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
> +}
> +
> +static ssize_t ks_retval_write(struct file *file, const char __user *ubuf,
> +			       size_t count, loff_t *ppos)
> +{
> +	struct ks_attr *attr = file->private_data;
> +	char buf[32];
> +	long val;
> +	int ret;
> +
> +	if (count >= sizeof(buf))
> +		return -EINVAL;
> +	if (copy_from_user(buf, ubuf, count))
> +		return -EFAULT;
> +	buf[count] = '\0';
> +	strim(buf);
> +
> +	ret = kstrtol(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&ks_lock);
> +	ret = ks_attr_check_live(attr);
> +	if (!ret)
> +		atomic_long_set(&attr->retval, val);
> +	mutex_unlock(&ks_lock);
> +
> +	return ret ? ret : count;
> +}
> +
> +static const struct file_operations ks_retval_fops = {
> +	.open		= ks_attr_open,
> +	.release	= ks_attr_release,
> +	.read		= ks_retval_read,
> +	.write	= ks_retval_write,
> +	.llseek	= default_llseek,
> +};
> +
> +static ssize_t ks_hits_read(struct file *file, char __user *ubuf,
> +			    size_t count, loff_t *ppos)
> +{
> +	struct ks_attr *attr = file->private_data;
> +	char buf[32];
> +	unsigned long hits;
> +	int ret, len;
> +
> +	mutex_lock(&ks_lock);
> +	ret = ks_attr_check_live(attr);
> +	hits = ks_attr_hits(attr);
> +	mutex_unlock(&ks_lock);
> +	if (ret)
> +		return ret;
> +	len = scnprintf(buf, sizeof(buf), "%lu\n", hits);
> +	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
> +}
> +
> +static const struct file_operations ks_hits_fops = {
> +	.open		= ks_attr_open,
> +	.release	= ks_attr_release,
> +	.read		= ks_hits_read,
> +	.llseek		= default_llseek,
> +};
> +
> +static int ks_create_attr_dir(struct ks_attr *attr)
> +{
> +	struct dentry *d;
> +
> +	attr->dir = securityfs_create_dir(attr->kp.symbol_name, ks_fn_dir);
> +	if (IS_ERR(attr->dir))
> +		return PTR_ERR(attr->dir);
> +
> +	/* ks_attr_open looks the attr up by name; i_private is unused. */
> +	d = securityfs_create_file("retval", 0600, attr->dir,
> +				   NULL, &ks_retval_fops);
> +	if (IS_ERR(d))
> +		goto err;
> +	d = securityfs_create_file("hits", 0400, attr->dir,
> +				   NULL, &ks_hits_fops);
> +	if (IS_ERR(d))
> +		goto err;
> +	return 0;
> +err:
> +	securityfs_remove(attr->dir);
> +	attr->dir = NULL;
> +	return PTR_ERR(d);
> +}
> +
> +/* ------------------------------------------------------------------ *
> + * Engage / disengage                                                 *
> + * ------------------------------------------------------------------ */
> +
> +static int __ks_engage(const char *symbol, long retval, bool from_cmdline)
> +{
> +	struct ks_attr *attr;
> +	int ret;
> +
> +	if (!symbol || !*symbol)
> +		return -EINVAL;
> +
> +	if (!from_cmdline) {
> +		ret = security_locked_down(LOCKDOWN_KILLSWITCH);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	mutex_lock(&ks_lock);
> +
> +	if (ks_attr_lookup(symbol)) {
> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}
> +
> +	attr = ks_attr_alloc(symbol);
> +	if (!attr) {
> +		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	atomic_long_set(&attr->retval, retval);
> +
> +	ret = register_kprobe(&attr->kp);
> +	if (ret) {
> +		pr_warn("killswitch: register_kprobe(%s) failed: %d\n",
> +			symbol, ret);
> +		ks_attr_put(attr);
> +		goto out_unlock;
> +	}
> +
> +	ret = ks_create_attr_dir(attr);
> +	if (ret) {
> +		unregister_kprobe(&attr->kp);
> +		ks_attr_put(attr);
> +		goto out_unlock;
> +	}
> +
> +	list_add_tail(&attr->list, &ks_engaged_list);
> +	attr->engaged = true;
> +	add_taint(TAINT_KILLSWITCH, LOCKDEP_STILL_OK);
> +
> +	if (from_cmdline) {
> +		pr_warn("killswitch: engage %s=%ld source=cmdline\n",
> +			symbol, retval);
> +	} else {
> +		pr_warn("killswitch: engage %s=%ld uid=%u auid=%u ses=%u comm=%s\n",
> +			symbol, retval,
> +			from_kuid(&init_user_ns, current_uid()),
> +			from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			audit_get_sessionid(current),
> +			current->comm);
> +	}
> +	ret = 0;
> +
> +out_unlock:
> +	mutex_unlock(&ks_lock);
> +	return ret;
> +}
> +
> +int killswitch_engage(const char *symbol, long retval)
> +{
> +	return __ks_engage(symbol, retval, false);
> +}
> +
> +static int __ks_disengage(const char *symbol)
> +{
> +	struct ks_attr *attr;
> +	unsigned long hits;
> +	int ret = 0;
> +
> +	mutex_lock(&ks_lock);
> +	attr = ks_attr_lookup(symbol);
> +	if (!attr) {
> +		ret = -ENOENT;
> +		goto out_unlock;
> +	}
> +
> +	unregister_kprobe(&attr->kp);
> +	attr->engaged = false;
> +	list_del(&attr->list);
> +	hits = ks_attr_hits(attr);
> +	securityfs_remove(attr->dir);
> +
> +	pr_warn("killswitch: disengage %s hits=%lu uid=%u auid=%u ses=%u comm=%s\n",
> +		symbol, hits,
> +		from_kuid(&init_user_ns, current_uid()),
> +		from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +		audit_get_sessionid(current),
> +		current->comm);
> +
> +	/* unregister_kprobe() already waited out in-flight pre-handlers. */
> +	ks_attr_put(attr);
> +
> +out_unlock:
> +	mutex_unlock(&ks_lock);
> +	return ret;
> +}
> +
> +int killswitch_disengage(const char *symbol)
> +{
> +	return __ks_disengage(symbol);
> +}
> +
> +bool killswitch_is_engaged(const char *symbol)
> +{
> +	bool engaged;
> +
> +	mutex_lock(&ks_lock);
> +	engaged = ks_attr_lookup(symbol) != NULL;
> +	mutex_unlock(&ks_lock);
> +	return engaged;
> +}
> +
> +static void ks_disengage_all_locked(void)
> +{
> +	struct ks_attr *attr, *n;
> +
> +	list_for_each_entry_safe(attr, n, &ks_engaged_list, list) {
> +		unregister_kprobe(&attr->kp);
> +		attr->engaged = false;
> +		list_del(&attr->list);
> +		securityfs_remove(attr->dir);
> +		pr_warn("killswitch: disengage %s hits=%lu (disengage_all)\n",
> +			attr->kp.symbol_name, ks_attr_hits(attr));
> +		ks_attr_put(attr);
> +	}
> +}
> +
> +/* ------------------------------------------------------------------ *
> + * Module unload: drop engagements on functions in the going module   *
> + * ------------------------------------------------------------------ */
> +
> +static int ks_module_notify(struct notifier_block *nb, unsigned long action,
> +			    void *data)
> +{
> +	struct module *mod = data;
> +	struct ks_attr *attr, *n;
> +
> +	if (action != MODULE_STATE_GOING)
> +		return NOTIFY_DONE;
> +
> +	mutex_lock(&ks_lock);
> +	list_for_each_entry_safe(attr, n, &ks_engaged_list, list) {
> +		if (!attr->kp.addr ||
> +		    __module_address((unsigned long)attr->kp.addr) != mod)
> +			continue;
> +
> +		pr_warn("killswitch: %s mitigation lost: module %s unloading; re-engage after reload if still needed\n",
> +			attr->kp.symbol_name, mod->name);
> +		unregister_kprobe(&attr->kp);
> +		attr->engaged = false;
> +		list_del(&attr->list);
> +		securityfs_remove(attr->dir);
> +		ks_attr_put(attr);
> +	}
> +	mutex_unlock(&ks_lock);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block ks_module_nb = {
> +	.notifier_call = ks_module_notify,
> +};
> +
> +/* ------------------------------------------------------------------ *
> + * Top-level securityfs files: control / engaged / taint              *
> + * ------------------------------------------------------------------ */
> +
> +static int ks_engaged_show(struct seq_file *m, void *v)
> +{
> +	struct ks_attr *attr;
> +
> +	mutex_lock(&ks_lock);
> +	list_for_each_entry(attr, &ks_engaged_list, list) {
> +		seq_printf(m, "%s retval=%ld hits=%lu\n",
> +			   attr->kp.symbol_name,
> +			   atomic_long_read(&attr->retval),
> +			   ks_attr_hits(attr));
> +	}
> +	mutex_unlock(&ks_lock);
> +	return 0;
> +}
> +
> +static int ks_engaged_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, ks_engaged_show, NULL);
> +}
> +
> +static const struct file_operations ks_engaged_fops = {
> +	.open		= ks_engaged_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +static ssize_t ks_taint_read(struct file *file, char __user *ubuf,
> +			     size_t count, loff_t *ppos)
> +{
> +	char buf[4];
> +	int len;
> +
> +	len = scnprintf(buf, sizeof(buf), "%d\n",
> +			test_taint(TAINT_KILLSWITCH) ? 1 : 0);
> +	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
> +}
> +
> +static const struct file_operations ks_taint_fops = {
> +	.open	= simple_open,
> +	.read	= ks_taint_read,
> +	.llseek	= default_llseek,
> +};
> +
> +/*
> + * control: parse one of:
> + *   engage <symbol> <retval>
> + *   disengage <symbol>
> + *   disengage_all
> + */
> +static ssize_t ks_control_write(struct file *file, const char __user *ubuf,
> +				size_t count, loff_t *ppos)
> +{
> +	char *buf, *cur, *verb, *sym, *retstr;
> +	long retval = 0;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (count == 0 || count > 4096)
> +		return -EINVAL;
> +
> +	buf = memdup_user_nul(ubuf, count);
> +	if (IS_ERR(buf))
> +		return PTR_ERR(buf);
> +
> +	cur = strim(buf);
> +	verb = strsep(&cur, " \t\n");
> +	if (!verb || !*verb) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!strcmp(verb, "disengage_all")) {
> +		mutex_lock(&ks_lock);
> +		ks_disengage_all_locked();
> +		mutex_unlock(&ks_lock);
> +		ret = count;
> +		goto out;
> +	}
> +
> +	sym = strsep(&cur, " \t\n");
> +	if (!sym || !*sym) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!strcmp(verb, "disengage")) {
> +		ret = __ks_disengage(sym);
> +		ret = ret ? ret : count;
> +		goto out;
> +	}
> +
> +	if (strcmp(verb, "engage")) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	retstr = strsep(&cur, " \t\n");
> +	if (!retstr || !*retstr) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if (kstrtol(retstr, 0, &retval)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = killswitch_engage(sym, retval);
> +	if (!ret)
> +		ret = count;
> +
> +out:
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static const struct file_operations ks_control_fops = {
> +	.open	= simple_open,
> +	.write	= ks_control_write,
> +	.llseek	= noop_llseek,
> +};
> +
> +/* ------------------------------------------------------------------ *
> + * Boot parameter:                                                    *
> + *   killswitch=fn1=-1,fn2=0,fn3=-22                                  *
> + * ------------------------------------------------------------------ */
> +
> +#define KS_BOOT_BUF 1024
> +static char ks_boot_buf[KS_BOOT_BUF] __initdata;
> +static bool ks_boot_present __initdata;
> +
> +static int __init ks_boot_setup(char *str)
> +{
> +	if (!str)
> +		return 0;
> +	strscpy(ks_boot_buf, str, sizeof(ks_boot_buf));
> +	ks_boot_present = true;
> +	return 1;
> +}
> +__setup("killswitch=", ks_boot_setup);
> +
> +static void __init ks_apply_boot_params(void)
> +{
> +	char *cur, *tok;
> +	long retval;
> +
> +	if (!ks_boot_present)
> +		return;
> +
> +	cur = ks_boot_buf;
> +	while ((tok = strsep(&cur, ",")) != NULL) {
> +		char *eq, *sym, *retstr;
> +
> +		if (!*tok)
> +			continue;
> +		eq = strchr(tok, '=');
> +		if (!eq) {
> +			pr_warn("killswitch: cmdline missing '=': %s\n", tok);
> +			continue;
> +		}
> +		*eq++ = '\0';
> +		sym = tok;
> +		retstr = eq;
> +
> +		if (kstrtol(retstr, 0, &retval)) {
> +			pr_warn("killswitch: cmdline bad retval %s=%s\n",
> +				sym, retstr);
> +			continue;
> +		}
> +
> +		if (__ks_engage(sym, retval, true))
> +			pr_warn("killswitch: cmdline engage %s failed\n", sym);
> +	}
> +}
> +
> +/* ------------------------------------------------------------------ *
> + * Init                                                               *
> + * ------------------------------------------------------------------ */
> +
> +static int __init killswitch_init(void)
> +{
> +	struct dentry *d;
> +
> +	ks_root_dir = securityfs_create_dir("killswitch", NULL);
> +	if (IS_ERR(ks_root_dir))
> +		return PTR_ERR(ks_root_dir);
> +
> +	d = securityfs_create_file("control", 0200, ks_root_dir,
> +				   NULL, &ks_control_fops);
> +	if (IS_ERR(d))
> +		goto err;
> +	d = securityfs_create_file("engaged", 0444, ks_root_dir,
> +				   NULL, &ks_engaged_fops);
> +	if (IS_ERR(d))
> +		goto err;
> +	d = securityfs_create_file("taint", 0444, ks_root_dir,
> +				   NULL, &ks_taint_fops);
> +	if (IS_ERR(d))
> +		goto err;
> +
> +	ks_fn_dir = securityfs_create_dir("fn", ks_root_dir);
> +	if (IS_ERR(ks_fn_dir)) {
> +		d = ks_fn_dir;
> +		goto err;
> +	}
> +
> +	register_module_notifier(&ks_module_nb);
> +	ks_apply_boot_params();
> +
> +	pr_info("killswitch: ready (sysfs at /sys/kernel/security/killswitch/)\n");
> +	return 0;
> +
> +err:
> +	securityfs_remove(ks_root_dir);
> +	return PTR_ERR(d);
> +}
> +late_initcall(killswitch_init);
> +
> +/* ------------------------------------------------------------------ *
> + * KUnit tests                                                        *
> + * ------------------------------------------------------------------ */
> +
> +#if IS_ENABLED(CONFIG_KUNIT)
> +#include <kunit/test.h>
> +
> +/* Non-static so kallsyms resolves them without CONFIG_KALLSYMS_ALL. */
> +int ks_kunit_target_int(int x);
> +void *ks_kunit_target_ptr(int x);
> +
> +#if __has_attribute(__noipa__)
> +# define KS_KUNIT_NOIPA __attribute__((__noipa__))
> +#else
> +# define KS_KUNIT_NOIPA noinline __noclone
> +#endif
> +
> +KS_KUNIT_NOIPA int ks_kunit_target_int(int x)
> +{
> +	return x + 1;
> +}
> +
> +KS_KUNIT_NOIPA void *ks_kunit_target_ptr(int x)
> +{
> +	return ERR_PTR(-EIO);
> +}
> +
> +static int ks_kunit_init(struct kunit *test)
> +{
> +	if (security_locked_down(LOCKDOWN_KILLSWITCH))
> +		kunit_skip(test, "integrity lockdown blocks killswitch_engage()");
> +	return 0;
> +}
> +
> +static int ks_kunit_init_lockdown(struct kunit *test)
> +{
> +	if (!security_locked_down(LOCKDOWN_KILLSWITCH))
> +		kunit_skip(test, "requires lockdown=integrity");
> +	return 0;
> +}
> +
> +static void ks_disengage_quiet(const char *sym)
> +{
> +	if (killswitch_is_engaged(sym))
> +		killswitch_disengage(sym);
> +}
> +
> +static void ks_test_engage_int(struct kunit *test)
> +{
> +	int ret;
> +
> +	ret = killswitch_engage("ks_kunit_target_int", -EPERM);
> +	KUNIT_EXPECT_EQ(test, ret, 0);
> +	KUNIT_EXPECT_EQ(test, ks_kunit_target_int(7), -EPERM);
> +	KUNIT_EXPECT_EQ(test, killswitch_disengage("ks_kunit_target_int"), 0);
> +	KUNIT_EXPECT_EQ(test, ks_kunit_target_int(7), 8);
> +}
> +
> +static void ks_test_double_engage(struct kunit *test)
> +{
> +	KUNIT_ASSERT_EQ(test,
> +		killswitch_engage("ks_kunit_target_int", 0), 0);
> +	KUNIT_EXPECT_EQ(test,
> +		killswitch_engage("ks_kunit_target_int", 0), -EBUSY);
> +	ks_disengage_quiet("ks_kunit_target_int");
> +}
> +
> +static void ks_test_disengage_unknown(struct kunit *test)
> +{
> +	KUNIT_EXPECT_EQ(test,
> +		killswitch_disengage("ks_kunit_target_int"), -ENOENT);
> +}
> +
> +static void ks_test_pointer_target(struct kunit *test)
> +{
> +	long retval = (long)(unsigned long)ERR_PTR(-EACCES);
> +
> +	KUNIT_ASSERT_EQ(test,
> +		killswitch_engage("ks_kunit_target_ptr", retval), 0);
> +	KUNIT_EXPECT_TRUE(test, IS_ERR(ks_kunit_target_ptr(0)));
> +	KUNIT_EXPECT_EQ(test, PTR_ERR(ks_kunit_target_ptr(0)), -EACCES);
> +	ks_disengage_quiet("ks_kunit_target_ptr");
> +}
> +
> +static void ks_test_taint_set(struct kunit *test)
> +{
> +	KUNIT_ASSERT_EQ(test,
> +		killswitch_engage("ks_kunit_target_int", 0), 0);
> +	KUNIT_EXPECT_TRUE(test, test_taint(TAINT_KILLSWITCH));
> +	ks_disengage_quiet("ks_kunit_target_int");
> +	/* taint must persist even after disengage */
> +	KUNIT_EXPECT_TRUE(test, test_taint(TAINT_KILLSWITCH));
> +}
> +
> +static void ks_test_hits_counter(struct kunit *test)
> +{
> +	struct ks_attr *attr;
> +	int i;
> +
> +	KUNIT_ASSERT_EQ(test,
> +		killswitch_engage("ks_kunit_target_int", 0), 0);
> +
> +	for (i = 0; i < 17; i++)
> +		(void)ks_kunit_target_int(i);
> +
> +	mutex_lock(&ks_lock);
> +	attr = ks_attr_lookup("ks_kunit_target_int");
> +	KUNIT_EXPECT_NOT_NULL(test, attr);
> +	if (attr)
> +		KUNIT_EXPECT_EQ(test, ks_attr_hits(attr), 17UL);
> +	mutex_unlock(&ks_lock);
> +
> +	ks_disengage_quiet("ks_kunit_target_int");
> +}
> +
> +static struct kunit_case ks_kunit_cases[] = {
> +	KUNIT_CASE(ks_test_engage_int),
> +	KUNIT_CASE(ks_test_double_engage),
> +	KUNIT_CASE(ks_test_disengage_unknown),
> +	KUNIT_CASE(ks_test_pointer_target),
> +	KUNIT_CASE(ks_test_taint_set),
> +	KUNIT_CASE(ks_test_hits_counter),
> +	{}
> +};
> +
> +static struct kunit_suite ks_kunit_suite = {
> +	.name = "killswitch",
> +	.init = ks_kunit_init,
> +	.test_cases = ks_kunit_cases,
> +};
> +
> +/*
> + * Lockdown suite. Skipped unless the kernel was booted with
> + * lockdown=integrity (or higher). Run together with
> + * killswitch=ks_kunit_target_int=... on the same cmdline to also
> + * exercise the cmdline-bypass and disengage-under-lockdown paths.
> + */
> +static void ks_test_lockdown_runtime_engage(struct kunit *test)
> +{
> +	KUNIT_EXPECT_EQ(test,
> +		killswitch_engage("ks_kunit_target_int", 0), -EPERM);
> +}
> +
> +static void ks_test_lockdown_cmdline_disengage(struct kunit *test)
> +{
> +	if (!killswitch_is_engaged("ks_kunit_target_int"))
> +		kunit_skip(test,
> +			   "requires killswitch=ks_kunit_target_int=... on cmdline");
> +	KUNIT_EXPECT_EQ(test,
> +		killswitch_disengage("ks_kunit_target_int"), 0);
> +}
> +
> +static struct kunit_case ks_kunit_lockdown_cases[] = {
> +	KUNIT_CASE(ks_test_lockdown_runtime_engage),
> +	KUNIT_CASE(ks_test_lockdown_cmdline_disengage),
> +	{}
> +};
> +
> +static struct kunit_suite ks_kunit_lockdown_suite = {
> +	.name = "killswitch_lockdown",
> +	.init = ks_kunit_init_lockdown,
> +	.test_cases = ks_kunit_lockdown_cases,
> +};
> +
> +kunit_test_suites(&ks_kunit_suite, &ks_kunit_lockdown_suite);
> +
> +#endif /* CONFIG_KUNIT */
> +
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 20feada5319d4..8ee174c7b7dd0 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -825,6 +825,7 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
>   	TAINT_FLAG(RANDSTRUCT,			'T', ' '),
>   	TAINT_FLAG(TEST,			'N', ' '),
>   	TAINT_FLAG(FWCTL,			'J', ' '),
> +	TAINT_FLAG(KILLSWITCH,			'H', ' '),
>   };
>   
>   #undef TAINT_FLAG
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8ff5adcfe1e0a..5770639c7b0ea 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -3349,6 +3349,19 @@ config TEST_HMM
>   
>   	  If unsure, say N.
>   
> +config TEST_KILLSWITCH
> +	tristate "Test module for the killswitch mitigation primitive"
> +	depends on KILLSWITCH && DEBUG_FS
> +	depends on m
> +	help
> +	  Build a module that exposes a deliberately-vulnerable function
> +	  ks_test_vuln() and a debugfs trigger /sys/kernel/debug/test_killswitch/fire.
> +	  The killswitch selftest in tools/testing/selftests/killswitch/
> +	  uses this to confirm engaging a killswitch suppresses the BUG()
> +	  the function would otherwise hit.
> +
> +	  If unsure, say N.
> +
>   config TEST_FREE_PAGES
>   	tristate "Test freeing pages"
>   	help
> diff --git a/lib/Makefile b/lib/Makefile
> index f33a24bf1c19a..d763225340674 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -100,6 +100,7 @@ obj-$(CONFIG_TEST_MEMCAT_P) += test_memcat_p.o
>   obj-$(CONFIG_TEST_OBJAGG) += test_objagg.o
>   obj-$(CONFIG_TEST_MEMINIT) += test_meminit.o
>   obj-$(CONFIG_TEST_LOCKUP) += test_lockup.o
> +obj-$(CONFIG_TEST_KILLSWITCH) += test_killswitch.o
>   obj-$(CONFIG_TEST_HMM) += test_hmm.o
>   obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
>   obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
> diff --git a/lib/test_killswitch.c b/lib/test_killswitch.c
> new file mode 100644
> index 0000000000000..cc2584ad652ff
> --- /dev/null
> +++ b/lib/test_killswitch.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test target for the killswitch selftest.  ks_test_vuln() returns
> + * -EBADMSG on a magic input, standing in for "the buggy path runs
> + * and produces a bad outcome".  Engaging killswitch on this function
> + * with retval 0 is the mitigation.
> + *
> + * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> + */
> +
> +#include <linux/debugfs.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +
> +#define KS_TEST_MAGIC	0xC0FFEEL
> +
> +int ks_test_vuln(long magic);
> +
> +/*
> + * Returns -EBADMSG on the magic input -- stands in for "the buggy
> + * path runs and produces a bad outcome".  Engaging a killswitch on
> + * this function with retval 0 represents the mitigation: even on
> + * the magic input, callers see success because the body never runs.
> + *
> + * noipa prevents inlining/IPA so the call actually reaches the
> + * kprobe-instrumented entry point.
> + */
> +noinline int ks_test_vuln(long magic)
> +{
> +	if (magic == KS_TEST_MAGIC)
> +		return -EBADMSG;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ks_test_vuln);
> +
> +static struct dentry *ks_test_dir;
> +
> +static ssize_t ks_test_fire_write(struct file *file, const char __user *ubuf,
> +				  size_t count, loff_t *ppos)
> +{
> +	char buf[32];
> +	long magic;
> +	int ret;
> +
> +	if (count == 0 || count >= sizeof(buf))
> +		return -EINVAL;
> +	if (copy_from_user(buf, ubuf, count))
> +		return -EFAULT;
> +	buf[count] = '\0';
> +
> +	ret = kstrtol(strim(buf), 0, &magic);
> +	if (ret)
> +		return ret;
> +
> +	ret = ks_test_vuln(magic);
> +	return ret ? ret : count;
> +}
> +
> +static const struct file_operations ks_test_fire_fops = {
> +	.write	= ks_test_fire_write,
> +	.open	= simple_open,
> +	.llseek	= noop_llseek,
> +};
> +
> +static int __init test_killswitch_init(void)
> +{
> +	ks_test_dir = debugfs_create_dir("test_killswitch", NULL);
> +	debugfs_create_file("fire", 0200, ks_test_dir, NULL,
> +			    &ks_test_fire_fops);
> +	pr_info("test_killswitch: loaded (magic=0x%lx)\n", KS_TEST_MAGIC);
> +	return 0;
> +}
> +module_init(test_killswitch_init);
> +
> +static void __exit test_killswitch_exit(void)
> +{
> +	debugfs_remove_recursive(ks_test_dir);
> +}
> +module_exit(test_killswitch_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Deliberately-vulnerable target for killswitch selftest");
> diff --git a/security/security.c b/security/security.c
> index 4e999f0236516..bf700abc911a9 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -62,6 +62,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX + 1] = {
>   	[LOCKDOWN_DBG_WRITE_KERNEL] = "use of kgdb/kdb to write kernel RAM",
>   	[LOCKDOWN_RTAS_ERROR_INJECTION] = "RTAS error injection",
>   	[LOCKDOWN_XEN_USER_ACTIONS] = "Xen guest user action",
> +	[LOCKDOWN_KILLSWITCH] = "engaging a killswitch",
>   	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
>   	[LOCKDOWN_KCORE] = "/proc/kcore access",
>   	[LOCKDOWN_KPROBES] = "use of kprobes",
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 6e59b8f63e416..04c3f8c5ff229 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -53,6 +53,7 @@ TARGETS += ipc
>   TARGETS += ir
>   TARGETS += kcmp
>   TARGETS += kexec
> +TARGETS += killswitch
>   TARGETS += kselftest_harness
>   TARGETS += kvm
>   TARGETS += landlock
> diff --git a/tools/testing/selftests/killswitch/.gitignore b/tools/testing/selftests/killswitch/.gitignore
> new file mode 100644
> index 0000000000000..cbf204ce18615
> --- /dev/null
> +++ b/tools/testing/selftests/killswitch/.gitignore
> @@ -0,0 +1 @@
> +cve_31431_test
> diff --git a/tools/testing/selftests/killswitch/Makefile b/tools/testing/selftests/killswitch/Makefile
> new file mode 100644
> index 0000000000000..ccf41165cb73d
> --- /dev/null
> +++ b/tools/testing/selftests/killswitch/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> +TEST_GEN_PROGS := cve_31431_test cve_43284_test
> +TEST_PROGS := killswitch_test.sh
> +
> +CFLAGS += -O2 -g -std=gnu99 -Wall $(KHDR_INCLUDES)
> +
> +include ../lib.mk
> diff --git a/tools/testing/selftests/killswitch/cve_31431_test.c b/tools/testing/selftests/killswitch/cve_31431_test.c
> new file mode 100644
> index 0000000000000..1ff817c51d881
> --- /dev/null
> +++ b/tools/testing/selftests/killswitch/cve_31431_test.c
> @@ -0,0 +1,162 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * AF_ALG AEAD round-trip prober.  The killswitch selftest uses this
> + * to demonstrate that engaging a killswitch on af_alg_sendmsg
> + * neuters AF_ALG operations (sendmsg returns -EPERM), mitigating
> + * any AF_ALG-reachable bug whose exploit primitive runs from the
> + * send path.
> + *
> + * Exit codes:
> + *   0  AEAD round-trip succeeded (function intact)
> + *   1  AEAD round-trip refused (mitigation engaged)
> + *   2  setup error (no AF_ALG, missing aead/gcm(aes), etc.) -> SKIP
> + *
> + * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> + */
> +
> +#include <errno.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <unistd.h>
> +#include <linux/if_alg.h>
> +
> +#define KEY_LEN		16
> +#define IV_LEN		12
> +#define AAD_LEN		16
> +#define PT_LEN		64
> +#define TAG_LEN		16
> +#define EXPECTED_LEN	(AAD_LEN + PT_LEN + TAG_LEN)
> +
> +#ifndef AF_ALG
> +#define AF_ALG		38
> +#endif
> +#ifndef SOL_ALG
> +#define SOL_ALG		279
> +#endif
> +
> +int main(void)
> +{
> +	struct sockaddr_alg sa = {
> +		.salg_family = AF_ALG,
> +		.salg_type   = "aead",
> +		.salg_name   = "gcm(aes)",
> +	};
> +	unsigned char key[KEY_LEN] = { 0 };
> +	unsigned char iv[IV_LEN]   = { 0 };
> +	unsigned char buf[1024]    = { 0 };
> +	struct msghdr msg = { 0 };
> +	struct iovec iov;
> +	struct cmsghdr *cmsg;
> +	struct af_alg_iv *aiv;
> +	char cbuf[256] = { 0 };
> +	int *p_op, *p_assoclen;
> +	int sk, opfd;
> +	ssize_t n;
> +
> +	sk = socket(AF_ALG, SOCK_SEQPACKET, 0);
> +	if (sk < 0) {
> +		fprintf(stderr, "AF_ALG socket: %s -- skip\n", strerror(errno));
> +		return 2;
> +	}
> +	if (bind(sk, (struct sockaddr *)&sa, sizeof(sa))) {
> +		fprintf(stderr, "bind aead/gcm(aes): %s -- skip\n",
> +			strerror(errno));
> +		close(sk);
> +		return 2;
> +	}
> +	if (setsockopt(sk, SOL_ALG, ALG_SET_KEY, key, KEY_LEN)) {
> +		fprintf(stderr, "ALG_SET_KEY: %s -- skip\n", strerror(errno));
> +		close(sk);
> +		return 2;
> +	}
> +	if (setsockopt(sk, SOL_ALG, ALG_SET_AEAD_AUTHSIZE, NULL, TAG_LEN)) {
> +		fprintf(stderr, "ALG_SET_AEAD_AUTHSIZE: %s -- skip\n",
> +			strerror(errno));
> +		close(sk);
> +		return 2;
> +	}
> +
> +	opfd = accept(sk, NULL, 0);
> +	if (opfd < 0) {
> +		fprintf(stderr, "accept: %s -- skip\n", strerror(errno));
> +		close(sk);
> +		return 2;
> +	}
> +
> +	/* control message: ENCRYPT op + IV + assoclen */
> +	msg.msg_control    = cbuf;
> +	msg.msg_controllen = CMSG_SPACE(sizeof(int))
> +			   + CMSG_SPACE(sizeof(*aiv) + IV_LEN)
> +			   + CMSG_SPACE(sizeof(int));
> +
> +	cmsg = CMSG_FIRSTHDR(&msg);
> +	cmsg->cmsg_level = SOL_ALG;
> +	cmsg->cmsg_type  = ALG_SET_OP;
> +	cmsg->cmsg_len   = CMSG_LEN(sizeof(int));
> +	p_op = (int *)CMSG_DATA(cmsg);
> +	*p_op = ALG_OP_ENCRYPT;
> +
> +	cmsg = CMSG_NXTHDR(&msg, cmsg);
> +	cmsg->cmsg_level = SOL_ALG;
> +	cmsg->cmsg_type  = ALG_SET_IV;
> +	cmsg->cmsg_len   = CMSG_LEN(sizeof(*aiv) + IV_LEN);
> +	aiv = (struct af_alg_iv *)CMSG_DATA(cmsg);
> +	aiv->ivlen = IV_LEN;
> +	memcpy(aiv->iv, iv, IV_LEN);
> +
> +	cmsg = CMSG_NXTHDR(&msg, cmsg);
> +	cmsg->cmsg_level = SOL_ALG;
> +	cmsg->cmsg_type  = ALG_SET_AEAD_ASSOCLEN;
> +	cmsg->cmsg_len   = CMSG_LEN(sizeof(int));
> +	p_assoclen = (int *)CMSG_DATA(cmsg);
> +	*p_assoclen = AAD_LEN;
> +
> +	/* AAD || plaintext */
> +	memset(buf, 0xaa, AAD_LEN);
> +	memset(buf + AAD_LEN, 0x55, PT_LEN);
> +	iov.iov_base = buf;
> +	iov.iov_len  = AAD_LEN + PT_LEN;
> +	msg.msg_iov    = &iov;
> +	msg.msg_iovlen = 1;
> +
> +	n = sendmsg(opfd, &msg, 0);
> +	if (n < 0) {
> +		/*
> +		 * sendmsg refused: this is exactly the killswitch
> +		 * af_alg_sendmsg=-EPERM mitigation outcome.  Distinct
> +		 * exit code from setup failure so the test script can
> +		 * tell them apart.
> +		 */
> +		fprintf(stderr, "sendmsg: %s -- mitigation engaged?\n",
> +			strerror(errno));
> +		close(opfd); close(sk);
> +		return 1;
> +	}
> +
> +	/* recv: AAD echoed, plus ciphertext + tag */
> +	memset(buf, 0, sizeof(buf));
> +	n = read(opfd, buf, EXPECTED_LEN);
> +	close(opfd); close(sk);
> +
> +	if (n == 0) {
> +		printf("AEAD returned 0 bytes -- killswitch mitigation engaged\n");
> +		return 1;
> +	}
> +	if (n != EXPECTED_LEN) {
> +		fprintf(stderr,
> +			"AEAD short read: got %zd, expected %d -- mitigated?\n",
> +			n, EXPECTED_LEN);
> +		return 1;
> +	}
> +
> +	/* sanity: ciphertext (after AAD) shouldn't equal the plaintext bytes */
> +	if (memcmp(buf + AAD_LEN, buf + AAD_LEN + 1, PT_LEN - 1) == 0) {
> +		fprintf(stderr, "AEAD output looks unencrypted\n");
> +		return 2;
> +	}
> +
> +	printf("AEAD round-trip OK (%zd bytes)\n", n);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/killswitch/cve_43284_test.c b/tools/testing/selftests/killswitch/cve_43284_test.c
> new file mode 100644
> index 0000000000000..4771cb0957dc1
> --- /dev/null
> +++ b/tools/testing/selftests/killswitch/cve_43284_test.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * UDP loopback round-trip prober.  Wrapped by killswitch_test.sh with
> + * an IPsec ESP SA + policy pair on loopback, this demonstrates that
> + * engaging a killswitch on esp_input drops inbound ESP packets before
> + * decapsulation, mitigating CVE-2026-43284 ("Dirty Frag", upstream fix
> + * xfrm: esp: avoid in-place decrypt on shared skb frags).
> + *
> + * The binary itself knows nothing about ESP -- it sends one UDP
> + * datagram to itself and waits up to a second for delivery.
> + *
> + * Exit codes:
> + *   0  UDP round-trip succeeded (no mitigation in effect)
> + *   1  UDP recv timed out (mitigation engaged)
> + *   2  setup error -> SKIP
> + *
> + * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> + */
> +
> +#include <arpa/inet.h>
> +#include <errno.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <sys/time.h>
> +#include <unistd.h>
> +
> +#define UDP_PORT 53435
> +#define PROBE    "ks-43284-probe"
> +
> +int main(void)
> +{
> +	struct sockaddr_in addr = {
> +		.sin_family      = AF_INET,
> +		.sin_port        = htons(UDP_PORT),
> +		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
> +	};
> +	struct timeval tv = { .tv_sec = 1, .tv_usec = 0 };
> +	char buf[64];
> +	int sk;
> +	ssize_t n;
> +
> +	sk = socket(AF_INET, SOCK_DGRAM, 0);
> +	if (sk < 0) {
> +		fprintf(stderr, "socket: %s -- skip\n", strerror(errno));
> +		return 2;
> +	}
> +	if (bind(sk, (struct sockaddr *)&addr, sizeof(addr))) {
> +		fprintf(stderr, "bind: %s -- skip\n", strerror(errno));
> +		close(sk);
> +		return 2;
> +	}
> +	if (setsockopt(sk, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv))) {
> +		fprintf(stderr, "SO_RCVTIMEO: %s -- skip\n", strerror(errno));
> +		close(sk);
> +		return 2;
> +	}
> +
> +	if (sendto(sk, PROBE, sizeof(PROBE) - 1, 0,
> +		   (struct sockaddr *)&addr, sizeof(addr)) < 0) {
> +		fprintf(stderr, "sendto: %s -- skip\n", strerror(errno));
> +		close(sk);
> +		return 2;
> +	}
> +
> +	memset(buf, 0, sizeof(buf));
> +	n = recvfrom(sk, buf, sizeof(buf), 0, NULL, NULL);
> +	close(sk);
> +
> +	if (n < 0) {
> +		if (errno == EAGAIN || errno == EWOULDBLOCK) {
> +			fprintf(stderr,
> +				"recvfrom: timeout -- mitigation engaged?\n");
> +			return 1;
> +		}
> +		fprintf(stderr, "recvfrom: %s\n", strerror(errno));
> +		return 2;
> +	}
> +	if (n != (ssize_t)(sizeof(PROBE) - 1) ||
> +	    memcmp(buf, PROBE, sizeof(PROBE) - 1)) {
> +		fprintf(stderr, "recvfrom: bad payload (%zd bytes)\n", n);
> +		return 2;
> +	}
> +
> +	printf("UDP round-trip OK (%zd bytes)\n", n);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/killswitch/killswitch_test.sh b/tools/testing/selftests/killswitch/killswitch_test.sh
> new file mode 100755
> index 0000000000000..ea3fd394a984f
> --- /dev/null
> +++ b/tools/testing/selftests/killswitch/killswitch_test.sh
> @@ -0,0 +1,254 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# End-to-end killswitch selftest.  Drives the test_killswitch module
> +# through an engage/disengage cycle and confirms each transition
> +# behaves as expected.  Also runs the AF_ALG mitigation proof.
> +#
> +# Requirements (see Documentation/admin-guide/killswitch.rst):
> +#   - CONFIG_KILLSWITCH=y
> +#   - CONFIG_TEST_KILLSWITCH=m
> +#   - run as root (CAP_SYS_ADMIN)
> +#
> +# Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
> +#
> +
> +set -u
> +
> +KS=/sys/kernel/security/killswitch
> +TRIG=/sys/kernel/debug/test_killswitch/fire
> +
> +NOMOD=0
> +SKIP_RC=4
> +N=0
> +FAIL=0
> +
> +ksft_pass() { N=$((N+1));    echo "ok $N - $*"; }
> +ksft_fail() { N=$((N+1)); FAIL=$((FAIL+1)); echo "not ok $N - $*"; }
> +ksft_skip() { echo "ok 1 - SKIP $*"; echo "1..1"; exit $SKIP_RC; }
> +
> +[[ $EUID -eq 0 ]] || ksft_skip "must be root"
> +[[ -d $KS    ]] || ksft_skip "$KS not present (CONFIG_KILLSWITCH disabled?)"
> +
> +if ! modprobe test_killswitch 2>/dev/null; then
> +	NOMOD=1
> +fi
> +[[ -e $TRIG ]] || ksft_skip "$TRIG missing (test_killswitch.ko not installed?)"
> +
> +cleanup() {
> +	echo "disengage_all" > $KS/control 2>/dev/null || true
> +	[[ $NOMOD -eq 0 ]] && rmmod test_killswitch 2>/dev/null || true
> +}
> +trap cleanup EXIT
> +
> +# --- pre-engage: bad path runs, write fails with EBADMSG ---
> +if echo 0xC0FFEE > $TRIG 2>/dev/null; then
> +	ksft_fail "pre-engage: write should have failed (-EBADMSG)"
> +else
> +	[[ $? -ne 0 ]] && ksft_pass "pre-engage: bad path returns error" \
> +	             || ksft_fail "pre-engage: unexpected outcome"
> +fi
> +
> +# --- engage ---
> +echo "engage ks_test_vuln 0" > $KS/control
> +grep -q "^ks_test_vuln" $KS/engaged \
> +	&& ksft_pass "engage: ks_test_vuln in engaged list" \
> +	|| ksft_fail "engage: missing from engaged list"
> +
> +[[ $(cat $KS/taint) == 1 ]] \
> +	&& ksft_pass "engage: taint set" \
> +	|| ksft_fail "engage: taint not set"
> +
> +[[ -d $KS/fn/ks_test_vuln ]] \
> +	&& ksft_pass "engage: per-fn dir created" \
> +	|| ksft_fail "engage: per-fn dir missing"
> +
> +# --- post-engage: BUG suppressed; write returns successfully ---
> +if echo 0xC0FFEE > $TRIG 2>/dev/null; then
> +	ksft_pass "post-engage: BUG suppressed, write succeeded"
> +else
> +	ksft_fail "post-engage: write should succeed"
> +fi
> +
> +[[ $(cat $KS/fn/ks_test_vuln/hits) -ge 1 ]] \
> +	&& ksft_pass "post-engage: hits counter incremented" \
> +	|| ksft_fail "post-engage: hits counter did not move"
> +
> +# --- retval rewrite is a plain write (no validation) ---
> +echo 7 > $KS/fn/ks_test_vuln/retval
> +[[ $(cat $KS/fn/ks_test_vuln/retval) == 7 ]] \
> +	&& ksft_pass "retval rewrite round-trips" \
> +	|| ksft_fail "retval rewrite failed"
> +
> +# --- engage on a kprobe-rejected function fails ---
> +# warn_thunk_thunk is in /sys/kernel/debug/kprobes/blacklist;
> +# register_kprobe() refuses it.
> +KP_REJECT=warn_thunk_thunk
> +if echo "engage $KP_REJECT 0" > $KS/control 2>/dev/null; then
> +	ksft_fail "register_kprobe should have rejected $KP_REJECT"
> +	echo "disengage $KP_REJECT" > $KS/control
> +else
> +	ksft_pass "register_kprobe refuses blacklisted target"
> +fi
> +
> +# --- disengage ---
> +echo "disengage ks_test_vuln" > $KS/control
> +[[ -z "$(cat $KS/engaged)" ]] \
> +	&& ksft_pass "disengage: engaged list empty" \
> +	|| ksft_fail "disengage: engaged list not empty"
> +
> +[[ ! -d $KS/fn/ks_test_vuln ]] \
> +	&& ksft_pass "disengage: per-fn dir removed" \
> +	|| ksft_fail "disengage: per-fn dir still present"
> +
> +[[ $(cat $KS/taint) == 1 ]] \
> +	&& ksft_pass "disengage: taint persists" \
> +	|| ksft_fail "disengage: taint should persist"
> +
> +# --- post-disengage: bad path active again ---
> +if echo 0xC0FFEE > $TRIG 2>/dev/null; then
> +	ksft_fail "post-disengage: write should fail again"
> +else
> +	ksft_pass "post-disengage: bad path active again"
> +fi
> +
> +# ---- CVE-2026-31431 mitigation proof (AF_ALG aead via af_alg_sendmsg) ----
> +# Skip the whole block if AF_ALG / AEAD machinery isn't compiled in.
> +if [[ -x $(dirname "$0")/cve_31431_test ]]; then
> +	CVE=$(dirname "$0")/cve_31431_test
> +	$CVE >/dev/null 2>&1 && PRE=$? || PRE=$?
> +	if [[ $PRE -eq 0 ]]; then
> +		ksft_pass "cve-31431: pre-engage AEAD round-trip OK"
> +
> +		echo "engage af_alg_sendmsg -1" > $KS/control
> +		$CVE >/dev/null 2>&1 && POST=$? || POST=$?
> +		if [[ $POST -eq 1 ]]; then
> +			ksft_pass "cve-31431: post-engage AEAD refused (mitigated)"
> +		else
> +			ksft_fail "cve-31431: post-engage exit=$POST (expected 1)"
> +		fi
> +
> +		HITS=$(cat $KS/fn/af_alg_sendmsg/hits 2>/dev/null || echo 0)
> +		[[ $HITS -ge 1 ]] && ksft_pass "cve-31431: hits=$HITS recorded" \
> +			|| ksft_fail "cve-31431: hits not recorded"
> +
> +		echo "disengage af_alg_sendmsg" > $KS/control
> +		$CVE >/dev/null 2>&1 && POST2=$? || POST2=$?
> +		[[ $POST2 -eq 0 ]] && ksft_pass "cve-31431: post-disengage restored" \
> +			|| ksft_fail "cve-31431: post-disengage exit=$POST2"
> +	elif [[ $PRE -eq 2 ]]; then
> +		echo "# SKIP cve-31431 (AF_ALG/AEAD not available)"
> +	else
> +		ksft_fail "cve-31431: pre-engage exit=$PRE"
> +	fi
> +fi
> +
> +# ---- CVE-2026-43284 mitigation proof (IPsec ESP via esp_input) ----
> +# Engaging esp_input causes inbound ESP packets to be dropped before
> +# decapsulation, neutering any bug downstream of the ESP receive path.
> +# Two netns + veth so traffic actually traverses xfrm (single-netns
> +# 127.0.0.0/8 traffic short-circuits before xfrm policy lookup).
> +NS0=ks-esp-0
> +NS1=ks-esp-1
> +esp_setup_ok=0
> +esp_cleanup() {
> +	[[ $esp_setup_ok -eq 1 ]] || return 0
> +	ip netns del $NS0 2>/dev/null
> +	ip netns del $NS1 2>/dev/null
> +}
> +trap 'cleanup; esp_cleanup' EXIT
> +
> +# UDP probe in python3 (always present on Debian/Fedora minimal installs).
> +esp_round_trip() {
> +	# $1: source netns, $2: dest netns, $3: dest ip, $4: port
> +	local tmp rpid rc
> +	tmp=$(mktemp)
> +	ip netns exec "$2" python3 -c '
> +import socket
> +r = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
> +r.bind(("0.0.0.0", '"$4"'))
> +r.settimeout(2.0)
> +try:
> +    d,_ = r.recvfrom(64)
> +    print(d.decode(errors="replace"))
> +except socket.timeout:
> +    print("timeout")
> +' > "$tmp" 2>&1 &
> +	rpid=$!
> +	sleep 0.3
> +	ip netns exec "$1" python3 -c '
> +import socket
> +s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
> +s.sendto(b"ks-esp-probe", ("'"$3"'", '"$4"'))
> +' 2>/dev/null
> +	wait $rpid 2>/dev/null
> +	rc=1
> +	grep -q "ks-esp-probe" "$tmp" && rc=0
> +	rm -f "$tmp"
> +	return $rc
> +}
> +
> +if command -v ip >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
> +	KEY=0x0123456789abcdef0123456789abcdef01234567
> +
> +	if ip netns add $NS0 2>/dev/null && \
> +	   ip netns add $NS1 2>/dev/null && \
> +	   ip link add veth0 type veth peer name veth1 2>/dev/null && \
> +	   ip link set veth0 netns $NS0 2>/dev/null && \
> +	   ip link set veth1 netns $NS1 2>/dev/null && \
> +	   ip -n $NS0 addr add 10.99.0.1/24 dev veth0 2>/dev/null && \
> +	   ip -n $NS1 addr add 10.99.0.2/24 dev veth1 2>/dev/null && \
> +	   ip -n $NS0 link set veth0 up 2>/dev/null && \
> +	   ip -n $NS1 link set veth1 up 2>/dev/null && \
> +	   ip -n $NS0 link set lo up 2>/dev/null && \
> +	   ip -n $NS1 link set lo up 2>/dev/null && \
> +	   ip -n $NS0 xfrm state add src 10.99.0.1 dst 10.99.0.2 proto esp \
> +		spi 0x1000 mode transport reqid 0x100 \
> +		aead 'rfc4106(gcm(aes))' $KEY 128 2>/dev/null && \
> +	   ip -n $NS0 xfrm state add src 10.99.0.2 dst 10.99.0.1 proto esp \
> +		spi 0x1001 mode transport reqid 0x100 \
> +		aead 'rfc4106(gcm(aes))' $KEY 128 2>/dev/null && \
> +	   ip -n $NS1 xfrm state add src 10.99.0.1 dst 10.99.0.2 proto esp \
> +		spi 0x1000 mode transport reqid 0x100 \
> +		aead 'rfc4106(gcm(aes))' $KEY 128 2>/dev/null && \
> +	   ip -n $NS1 xfrm state add src 10.99.0.2 dst 10.99.0.1 proto esp \
> +		spi 0x1001 mode transport reqid 0x100 \
> +		aead 'rfc4106(gcm(aes))' $KEY 128 2>/dev/null && \
> +	   ip -n $NS0 xfrm policy add src 10.99.0.1 dst 10.99.0.2 \
> +		dir out tmpl src 10.99.0.1 dst 10.99.0.2 proto esp \
> +		reqid 0x100 mode transport 2>/dev/null && \
> +	   ip -n $NS1 xfrm policy add src 10.99.0.1 dst 10.99.0.2 \
> +		dir in tmpl src 10.99.0.1 dst 10.99.0.2 proto esp \
> +		reqid 0x100 mode transport 2>/dev/null; then
> +		esp_setup_ok=1
> +	fi
> +
> +	if [[ $esp_setup_ok -eq 1 ]] \
> +	   && esp_round_trip $NS0 $NS1 10.99.0.2 53435; then
> +		ksft_pass "cve-43284: pre-engage ESP round-trip OK"
> +
> +		echo "engage esp_input -22" > $KS/control
> +		if esp_round_trip $NS0 $NS1 10.99.0.2 53435; then
> +			ksft_fail "cve-43284: post-engage ESP should have been dropped"
> +		else
> +			ksft_pass "cve-43284: post-engage ESP refused (mitigated)"
> +		fi
> +
> +		ESP_HITS=$(cat $KS/fn/esp_input/hits 2>/dev/null || echo 0)
> +		[[ $ESP_HITS -ge 1 ]] \
> +			&& ksft_pass "cve-43284: hits=$ESP_HITS recorded" \
> +			|| ksft_fail "cve-43284: hits not recorded"
> +
> +		echo "disengage esp_input" > $KS/control
> +		if esp_round_trip $NS0 $NS1 10.99.0.2 53435; then
> +			ksft_pass "cve-43284: post-disengage restored"
> +		else
> +			ksft_fail "cve-43284: post-disengage ESP still dropped"
> +		fi
> +	else
> +		echo "# SKIP cve-43284 (netns/veth/XFRM/ESP setup failed)"
> +	fi
> +fi
> +
> +echo "1..$N"
> +exit $((FAIL > 0))

