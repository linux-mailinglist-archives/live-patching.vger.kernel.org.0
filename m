Return-Path: <live-patching+bounces-2930-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJBNFlQhGWqnqggAu9opvQ
	(envelope-from <live-patching+bounces-2930-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 07:17:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 553635FD485
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 07:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 48738300AD94
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682A33254A8;
	Fri, 29 May 2026 05:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XX4CZiej"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F15221E097
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 05:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780031821; cv=none; b=j0GLnukZfM5X16z24xpDsGdqo6hWVE8rKilOfcsvp1Js/pWhVPFXvxnScXy26KCkQP/w6NimjgQV9p19VbyXNUFWlkhvUWBY0aYYZYAobDJin3jvzYDBd3MMXIviZl31tk1TzNzmB2/7dAy97rvv/K1cvAjiqZItRVLZ2NGae7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780031821; c=relaxed/simple;
	bh=gYWyYnsHw+slL4itxOegm9AKy1tA2huh9bBu/xlD/+0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uVAI+kym/S06lYcfx/3cQ6H0GqXJPe4JS/vX21z2rtAGPSMGDvdFE1ArAqEEtCNeySDPjzv0mqd9jqMfNcen9NhLK/ccF7J6oN4Jis5nEP75u5NW6AwiAhJymyNCvNv0q4jdVT6Y8UkDQXsOT7IedYBxl8MoZSCri/ZMOg+7K08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XX4CZiej; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA391F00893;
	Fri, 29 May 2026 05:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780031820;
	bh=Vb+jnipy2ReA35yJuhRiE2nXBGEC6nePk5SjXKwn3ro=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XX4CZiej8vbOuNIiBh8q92ssmabgnbwxu8zK58SqR+B7x1yLGuB0WLZtVip96ToKy
	 aWah6msFSy9eawvvhOXvXFjfS+GMHdF/OtWUHzVoD8hMuSxBpM4+k6q4PmwtUs1rbk
	 ePSZ4OcTQQ9h8ceFkweMbiLjv9NocJbVbnz4LcujFy1d2UrV0u+8275/iXasCdDWUH
	 v1js/z1zZIXeHKl3ZNBOJoKvPqvvouRkt5E4ne5lM4GbB3ke/lqpT1tkTl7cTN9RWm
	 onQGN4zTNpoIpuU6cdeAJvwZSUQsisAtDbA4LJX2WwpU6ZdhnH1MQn9T9zZ7GPFVL0
	 CUaGo1bh8u0Rg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] selftests/livepatch: Update tests for
 replace_set
Reply-To: sashiko-reviews@lists.linux.dev
To: jikos@kernel.org, mbenes@suse.cz, song@kernel.org, joe.lawrence@redhat.com, pmladek@suse.com, jpoimboe@kernel.org
Cc: "Yafang Shao" <laoar.shao@gmail.com>, live-patching@vger.kernel.org
In-Reply-To: <20260529034542.68766-5-laoar.shao@gmail.com>
References: <20260529034542.68766-5-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 29 May 2026 05:16:59 +0000
Message-Id: <20260529051659.BEA391F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [1.34 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2930-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,lists.linux.dev:replyto,smtp.kernel.org:mid]
X-Rspamd-Queue-Id: 553635FD485
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The 'atomic replace livepatch' test case in test-livepatch.sh wa=
s completely removed instead of being updated, resulting in lost test cover=
age and leaving behind dead variables.
--

commit 99bb60c2ba8319ec21289c482f1ea304e282396c
Author: Yafang Shao <laoar.shao@gmail.com>

selftests/livepatch: Update tests for replace_set

This commit updates the livepatch selftests to use "replace_set" instead
of "replace". It configures different livepatches to share or have different
replace_sets to test atomic and non-atomic replace behaviors.

> diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/=
testing/selftests/livepatch/test-livepatch.sh
> index c44c5341a2f1e..042999856267f 100755
> --- a/tools/testing/selftests/livepatch/test-livepatch.sh
> +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
[ ... ]
> @@ -108,96 +108,6 @@ livepatch: '$MOD_LIVEPATCH1': completing unpatching =
transition
>  livepatch: '$MOD_LIVEPATCH1': unpatching complete
>  % rmmod $MOD_LIVEPATCH1"
> =20
> -
> -# - load a livepatch that modifies the output from /proc/cmdline and
> -#   verify correct behavior
> -# - load two additional livepatches and check the number of livepatch mo=
dules
> -#   applied
> -# - load an atomic replace livepatch and check that the other three modu=
les were
> -#   disabled
> -# - remove all livepatches besides the atomic replace one and verify tha=
t the
> -#   atomic replace livepatch is still active
> -# - remove the atomic replace livepatch and verify that none are active
> -
> -start_test "atomic replace livepatch"
> -
> -load_lp $MOD_LIVEPATCH1

[Severity: Medium]
Was this test case intentionally removed completely instead of being update=
d for
the new replace_set semantics?

The commit message does not mention removing this test. This removal causes=
 a
loss of test coverage that previously verified an atomic replace successful=
ly
disables multiple existing livepatches.

Additionally, removing this test leaves the script variables MOD_LIVEPATCH2
and MOD_LIVEPATCH3 unused in test-livepatch.sh. Could this test be adapted
to use replace_set instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260529034542.6876=
6-1-laoar.shao@gmail.com?part=3D4

