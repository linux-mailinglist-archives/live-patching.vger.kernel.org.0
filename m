Return-Path: <live-patching+bounces-2933-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wAb+IXtZGWqtvggAu9opvQ
	(envelope-from <live-patching+bounces-2933-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 11:16:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E5F5FFC9A
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 11:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 39CB930FCF82
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 09:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8D73BBA0E;
	Fri, 29 May 2026 09:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AyXMUALW"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F45F3BCD34
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 09:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780046012; cv=pass; b=rGWmHVMUXqH9le5XcirJegndWruntYioi9vrgdv8EeKL8eRWKdFS2/W3cw+qC5D1yrpU9hfQJadLSkDDF7H85gs3ULtRctRhgSWu/MmrKe6jL94M5cLQgO6FUEksQBwHqmSO13tC49OwgEQA/z/soJfscF/vHGKrIvrh+G65nwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780046012; c=relaxed/simple;
	bh=mFgyW51XJtXmhibZbBxCoAPVtlMwzEjgouicA3QDCvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgyYHVTjsZXx2DyQBHhdDdZzMuwE+zSrEJklfp4zX2xqEHJWRnRWjoEhXd4Xbd0EIqMDNgRlm6o7+tFKHvt3p9KBza8jfi+54OgMQPPD6kITZbti5k/JuvgaysySWPTPf5oMEBy4zCj40p1UlXebOAaRlRlJnGAuQjUzpcFDUx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AyXMUALW; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7c0de780bf1so123840847b3.2
        for <live-patching@vger.kernel.org>; Fri, 29 May 2026 02:13:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780046010; cv=none;
        d=google.com; s=arc-20240605;
        b=lGxWj5ysHwtUqzUQzozlwL7AVbIf/gqBH3Fs0XYeShntYgHd9RoTiFAfzxe22ZXI/p
         0FA+5KxCvQpTS3899LgRfc7qApz8AsVtwircgeeZeyi9bGRHgNDKeOJP8Mkb4jGx8Y6y
         fp5fFaFeXSQTSKnD6eB4kHRBZijKYuDIglOgeqRIPYnNbf8Jyy0JtBLYjUP9G6iW7vvf
         FCm79Ke5JzV1y2Ic0gXBlJP6vO8d4DlHnp7Mt5v6Uuw0MkzziEZgmH6nh7ZbrqI/AfDc
         +x+NKCJJYODdjWjaJWJT/WrEgEQNre/d46FEnZH7JbThk5LkAMlGwB+s5tDGknAqUXc0
         dyGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H6S6E6qC/OtWWeTZr1Pvf9wjq3ql7UjQmU9GicaWAcg=;
        fh=ZU4XY1Ra3+Bu+jnMmq7Ad4NzcO5/5MK5oH6jfeiQsjs=;
        b=J/OlWDdyrvGXYL15gNceeythYcRHRxqIJFBVyf7wns91ljRClsNqtyHXEmi1IcL0j4
         RLB3W+LZsB+MZOoQuq87sddeUMxpfx8WvNgPbbWyDPnCJHjR+4oXCnGJHAr5lcANitEl
         e7HJVjfxaGVnwKXhmxN072P0Oj9ft+AnwMvCnsom6GZnfNUDEfi88Ic2iWNnRHKuAgDI
         mQHg5zmOqZPZLJGxhpGbOJm963FcjwcMMbIKOR0YnwNWFQjzrSyLEP4NbRcPsACZBmzz
         GzMUEP7BT3YQlVj3SD8jvf90sk3eSsjN5UciGIGlmaUSXA5un/LcPctgHn6etZ5SGjDg
         kpcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780046010; x=1780650810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6S6E6qC/OtWWeTZr1Pvf9wjq3ql7UjQmU9GicaWAcg=;
        b=AyXMUALWLo63N6aYcRfZZ0htru5jCmZS8kVUQoq1/kvI0WC7bhrXQ4Oubfxii5uBep
         6TSRtdfzB0fw1YOEyFtJ6tfEtFvxieqlpDOeIlbFYDb2cdqHaWgeiNnbRUdFFcnIFaso
         cf7XktBGq6iEZ0NHfpQWsVmcQbeV+N1GQLkJ5TZGXkG5pc/uDnDthd4FCCm1MhDBSw4c
         NnBqdbNZ/+COukcYx0HV2Sntl/eUctoe+yZ6uHf+xi9CZYIQo1cefn8Wv3Y8ywnDA/eb
         8VtFCeHlOCtysKwpBhR8647CdwX0NKWrq6SRO9JbY3oxXgps9NAQlKPi1XW0uw5Go9Wy
         ibqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780046010; x=1780650810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H6S6E6qC/OtWWeTZr1Pvf9wjq3ql7UjQmU9GicaWAcg=;
        b=NoIAb5jquFFHiMwUOOsD/ildVps0ca79Niw01ubBMzMyLspVrMQhtcV5HZdCoIXV7X
         nKrF3w9c0fAP+OCtFHp/6m6IPsUsZ7MgO/VRr70WCAKwiedMdDkhl98TAhSYlx4KpRXC
         0J0dFZaeaRA0YmWv2FDiwglNLq9OfUYjTCf/kPdKo4hnk5ee2uvHbsXGpWgaqpaSmRHU
         poFJTsf+GX8oZ8qykrwn7q5OqsxP/rvP61Jr6qVIltJrYkFk7MnFDzsbJ2mlOOscu09H
         K/CO1JYy2rsAiURQQGay8+YCS7EsLugl2zD5imVNCnlcCfOsaJkh1i0JTNCwr33A07Zb
         8ZhA==
X-Forwarded-Encrypted: i=1; AFNElJ+u31UlpYYuKzY/kgZ6y/g+d0L5uHwUQSNaDmxbBGwpmTNJALSONiZuA6Dmy7MbaHRzaO5uX4VcrYqs4Vlr@vger.kernel.org
X-Gm-Message-State: AOJu0YwSvpLrXzZVIvAe2Xv0CTb8WkY0NM9QROfgZv0SF5X0n14fyo5U
	BOAF8FRE5ZJjeF3Iql4VCytp2j8+N8xma4W60eRCsn5ji5CnPO/dVB13boPYbemz9u0vxAQv7Eg
	1B/nrj4WPQjdy3TxeiBzaxbYvowLewvs=
X-Gm-Gg: Acq92OGxZmV61RFsOU4ZIU6Zkj60jPJaWnOszWHTAJUFCxqhU3LBHmR/vijg5UdI+NT
	I64wF8XQhOjICJozHPkZuBA+6+CtmDFk7WTq7bPL5H3G/7IaPUZCOBQLnB7SVyXcXovSg5Y0acz
	igU7hcdBrxGQM6FXhVc9wkSw3b5q7zGbrP+jyi9BAE/TTzqj8HtrCl9Wo5TBYd/KnLkE+SUTXgX
	jEHzxkp5YM3Ihh2n/YCRZ+0z+MWBXFe7Dw3R5mk7/hviapTrmHf8RZaGGRHmqQYd9ynODK/HCWl
	HsgS1Fn612S0i5Gbb1CJxifdi8g+A2L1sJmjPOKeCOLD7cTYug==
X-Received: by 2002:a05:690c:610a:b0:7a4:80ce:8275 with SMTP id
 00721157ae682-7de4ba34f6cmr13666347b3.35.1780046010439; Fri, 29 May 2026
 02:13:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529034542.68766-5-laoar.shao@gmail.com> <20260529051659.BEA391F00893@smtp.kernel.org>
In-Reply-To: <20260529051659.BEA391F00893@smtp.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 29 May 2026 17:12:53 +0800
X-Gm-Features: AVHnY4ICwHysqK3ued6uXyRS3cOpRunwhARwEIjxHUzL-4Ob9NoMLNSbAzL8Ba8
Message-ID: <CALOAHbAbz6BFMj+T5QSj672+kxig5FCx13OWth4BHZVhQXLB-w@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] selftests/livepatch: Update tests for replace_set
To: sashiko-reviews@lists.linux.dev
Cc: jikos@kernel.org, mbenes@suse.cz, song@kernel.org, joe.lawrence@redhat.com, 
	pmladek@suse.com, jpoimboe@kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2933-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,test-livepatch.sh:url]
X-Rspamd-Queue-Id: 07E5F5FFC9A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 29, 2026 at 1:17=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] The 'atomic replace livepatch' test case in test-livepatch.sh =
was completely removed instead of being updated, resulting in lost test cov=
erage and leaving behind dead variables.
> --
>
> commit 99bb60c2ba8319ec21289c482f1ea304e282396c
> Author: Yafang Shao <laoar.shao@gmail.com>
>
> selftests/livepatch: Update tests for replace_set
>
> This commit updates the livepatch selftests to use "replace_set" instead
> of "replace". It configures different livepatches to share or have differ=
ent
> replace_sets to test atomic and non-atomic replace behaviors.
>
> > diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tool=
s/testing/selftests/livepatch/test-livepatch.sh
> > index c44c5341a2f1e..042999856267f 100755
> > --- a/tools/testing/selftests/livepatch/test-livepatch.sh
> > +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
> [ ... ]
> > @@ -108,96 +108,6 @@ livepatch: '$MOD_LIVEPATCH1': completing unpatchin=
g transition
> >  livepatch: '$MOD_LIVEPATCH1': unpatching complete
> >  % rmmod $MOD_LIVEPATCH1"
> >
> > -
> > -# - load a livepatch that modifies the output from /proc/cmdline and
> > -#   verify correct behavior
> > -# - load two additional livepatches and check the number of livepatch =
modules
> > -#   applied
> > -# - load an atomic replace livepatch and check that the other three mo=
dules were
> > -#   disabled
> > -# - remove all livepatches besides the atomic replace one and verify t=
hat the
> > -#   atomic replace livepatch is still active
> > -# - remove the atomic replace livepatch and verify that none are activ=
e
> > -
> > -start_test "atomic replace livepatch"
> > -
> > -load_lp $MOD_LIVEPATCH1
>
> [Severity: Medium]
> Was this test case intentionally removed completely instead of being upda=
ted for
> the new replace_set semantics?
>
> The commit message does not mention removing this test. This removal caus=
es a
> loss of test coverage that previously verified an atomic replace successf=
ully
> disables multiple existing livepatches.

This test case is invalid for the replace_set, since only one
livepatch will be replaced.

>
> Additionally, removing this test leaves the script variables MOD_LIVEPATC=
H2
> and MOD_LIVEPATCH3 unused in test-livepatch.sh. Could this test be adapte=
d
> to use replace_set instead?

I will update it.

--=20
Regards
Yafang

