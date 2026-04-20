Return-Path: <live-patching+bounces-2398-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id hRcYJHez5WnOnAEAu9opvQ
	(envelope-from <live-patching+bounces-2398-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 07:02:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D6FC1426C84
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 07:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A4E5300F13B
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 05:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D8F2D6409;
	Mon, 20 Apr 2026 05:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OzQyL/dx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8689E2874E3
	for <live-patching@vger.kernel.org>; Mon, 20 Apr 2026 05:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776661362; cv=pass; b=EnB+q1giks9e+DfCiyCZgNz7U3Kp2NkHg8IAgb9s/v6Izp3Sx2GkdtZzD7HbZXUAOITKy7t4C1rPDweNvdBa1C+p9ja6duzx4sfaswv5BnpLAc2qXKWC1dRiVx9T1Je/TmdH01ToBuF7E89BqHHogN8UgO6k+P6vhPUZyv/x8b4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776661362; c=relaxed/simple;
	bh=MMOFJBIxaEM+fY+Iio0ErePhpxnqU0mnB7+2FT01i04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EqQF+BAbCLsnCagEBDtR028ndex3qV3ztnil0kPz177PhZHKY4V8hBtM4m1lnpcVVpdaomFRJgPTiqxi5U7LyErwstZu+9KqnkrvFEEIdm1RKVE9Jnp2VdJFQ3AHrPusOGfLmKWdSegC4bIyMp+6Hzq31rDUhpNEDVXVlUCdYqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OzQyL/dx; arc=pass smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-606045ef716so2078872137.0
        for <live-patching@vger.kernel.org>; Sun, 19 Apr 2026 22:02:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776661360; cv=none;
        d=google.com; s=arc-20240605;
        b=KLDk5KAxpo7wbp15EcfON3HzpmTthK9uuCynWQqpa2IeJV6OeWiNKUWxz6yv4xwfJP
         OCzM9vUGqeOqowqFQJDd0WVo3nJSO7fehfeFqt9HYinoTcN3r4qRsvycB3FmXHNjs0dq
         +FlFQOqUBdMg3JNv2fHHrXH1kCg1D4YaqF5swXSPjxUkKKfwhDjD2eRslk2g0xxkbFOp
         SeHMHw+SNlyJFwYjqbz7bxik3XhRb8KBaP3shf6sib8KtQcfeL5IvQKjklk/J3ebcwTo
         2oO9RP+5Hp/GHk799tTDW3VBGeb2LPYUvk4L4j5EhXY1NIcDXlmMV45UDCkQVQKz2i6k
         vWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GDoxCCxrGEpnif0U3GdL77JMYxIgwE31nWai8xD0wt8=;
        fh=ake1CHR3swD7a/Blj0R/NyvW5JerPDHAY/qUq5zJCKg=;
        b=N8EA7URRzRjTlpbzEAeFRbWluzwLGcGU06+oNUnxyMRrSnxxsiGuopJ9eEm7SOYWsO
         qZq+Pct5ouCDGI/HAEkpLryZyMY5w6108txqzBU7plX22deOptQ6fyy3Hf8t4+YallaO
         wDjxRPLqiEVAS2veRZJPQQ4PCDMQzTFv4aquFPEmTz7R3rVbkIhD/i1U4PL53sUqVfKw
         w6RGzXlblVWbk5mMIngwaefo8eBJVlxenfto36Sh/t+FuCOE6t7mJTNDJZa0WkHn5k9z
         BKNiP4ZUfq6II71QNiW3JhfGxHxZ92i0+TD2vh6kv+JTX9D96KPEvso4yezGSqGL9Ntn
         sIqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776661360; x=1777266160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDoxCCxrGEpnif0U3GdL77JMYxIgwE31nWai8xD0wt8=;
        b=OzQyL/dxFTrBfGjgiPTXazWKGuHJtrpTxuZtis0XUY0ANX2lknKgpLnveKRftT1OTx
         cSCKJ5xViKC97aRzafRfvPUvn0ufS4bmWbTjM+VlNg/MIUTns17bosu/iS6ESSEe9dph
         CgcjNRGMArsOVWDYEALYz6PKqBh8TUl5V1lIDkKkeazPBUkcqGCfxVzzd5eypx7GVjvd
         qvnXs+Ad/+pOr7pxQxvYtxgg24zveJ8KboUY47bSMBDZAaujWQghp0nZvT/R+dN0BKed
         zPcZHENB1sFNHWaRKXnDmOSnfMgBBX+/EUTkmj7peO8PW7G9nKhIQeBCPilUuSXb54Bo
         LmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776661360; x=1777266160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GDoxCCxrGEpnif0U3GdL77JMYxIgwE31nWai8xD0wt8=;
        b=NrkNFE84JWZ0vezflgIHE3l7iyne7VtOcweT62nIRE40rsHtUHr6wkKIJQsFA0BPjy
         JkYfUrBZNV6UTZvL23R+6qnhb2NepVBprn6nfymtB9B6rgwOz90vUnxug3b85KoS8tUk
         SwMbD0n0LjjWszV2ra5DMvmSfQm9t31Ulq69+NPcpi7D2g4025S3MnyFirZ9ijk2F6GI
         p+1Mv9D1vAtBCvioDWbpk28Dv3nEzaZLYnVl7Sjde+769sWIL9F0iHpHH+rAm3u7AEjL
         uxfGfxE+0MZMhIZlKbHVMrdbkaCYNzdSHsaBhXinbWiVR2t2vpPSrFhaE+Nkp8K2BjpL
         5oCw==
X-Forwarded-Encrypted: i=1; AFNElJ+3oRBKUkhuTD55RCV3s1QaKAFr3wT2qngD4iDnHSXCtRmSw4/Dxg8+brtwMV+dJfwHFrQoYszhJlZpxlWS@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcwfe1PnGPOvdqi5uFZ7CEVeuMLxpYaEksgAQp7Ev2ubGhzxsQ
	Ml65U21o38dQTC4gnTFvzFAkoPRT8tGmVgUoqPP1TtTHlAM1xRgX/VYbw+4n611luJnlTY44W+k
	hEG1p6oTClreTAZRKn/Ui2L3ybW8yz/cb9xBF63+r
X-Gm-Gg: AeBDiesMmfIVsIRBCLhVzNpbrvCHBDR04OKv2j99QIarPWAjpAODKYHubJYnhk5cU53
	1/5xNhfnlsdHEAexGrbtbjK9SojHHjIrUf6Yw6micavoX3PcR9h6LUtmeHHnwVi1mQdxzWRZC3i
	1m11ot5GUMizMfdBcr+IydAo5SduUjrRc7U2GyYd7XyhvhgXyRC+kYeudH3n988ndbTCQFvmgyX
	wKOTw5iKUo7rI/W+HUl0CBO6oCQKRnrqMqaZZoBCccGb5nkG0WpW+taXxCQHvf1fO8Y+z5XHI+Q
	Gw9rYs+zzWt9wbvjXWfne/YrzxRJ
X-Received: by 2002:a05:6102:4429:b0:602:9977:a4f5 with SMTP id
 ada2fe7eead31-616f7841746mr5442363137.27.1776661360013; Sun, 19 Apr 2026
 22:02:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-8-dylanbhatch@google.com> <de7bd273-3650-4378-8fd8-a51217e7284b@linux.ibm.com>
In-Reply-To: <de7bd273-3650-4378-8fd8-a51217e7284b@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Sun, 19 Apr 2026 22:02:28 -0700
X-Gm-Features: AQROBzCBNcOyW-40KDswAXPsMnzMW6-8REr7qR9V4RNPB3Nxd-zNK2Keg1pi2tU
Message-ID: <CADBMgpzbEGTm-sZ71a5hvFOHbu5VgSR406F3NsMLF1+oDWbO6A@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION.
To: Jens Remus <jremus@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2398-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D6FC1426C84
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 8:04=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
> Hello Dylan!
>
> On 4/6/2026 8:49 PM, Dylan Hatch wrote:
> > Generalize the __safe* helpers to support a non-user-access code path.
> > Allow for kernel FDE read failures due to the presence of .rodata.text.
> > This section contains code that can't be executed by the kernel
> > direclty, and thus lies ouside the normal kernel-text bounds.
>
> Nits: s/direclty/directly/ s/ouside/outside/
>
> Could you please explain the issue?  How/why does .sframe for
> .rodata.text pose an issue for .sframe verification?

__read_fde checks that the fde_addr it extracts is within the bounds
of sec->text_start and sec->text_end. In the case of the vmlinux
.sframe section, this is _stext and _etext. However on arm64, there is
an .rodata.text section that lies outside this range. From
arch/arm64/kernel/vmlinux.lds.S:

        /* code sections that are never executed via the kernel mapping */
        .rodata.text : {
                TRAMP_TEXT
                HIBERNATE_TEXT
                KEXEC_TEXT
                IDMAP_TEXT
                . =3D ALIGN(PAGE_SIZE);
        }

So __read_fde fails for functions in this section. Under normal SFrame
usage for unwinding, we should never need to look up a PC value in
these functions because they will never be executed by the kernel.
However, we still hit this error when validating all FDEs.

I think ideally we might prevent sframe data from being generated for
this code (maybe from the linker script somehow?), but I don't know of
a simple way to do this. Alternatively, we can check for FDEs located
in .rodata.text during validation, but this seems to only be present
in arm64, so maybe we would need an arch-specific hook to do this? I'm
open to suggestions.

>
> > Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
>
> > diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
>
> > @@ -690,6 +699,13 @@ static int sframe_validate_section(struct sframe_s=
ection *sec)
> >               int ret;
> >
> >               ret =3D safe_read_fde(sec, i, &fde);
> > +             /*
> > +              * Code in .rodata.text is not considered part of normal =
kernel
> > +              * text, but there is no easy way to prevent sframe data =
from
> > +              * being generated for it.
> > +              */
> > +             if (ret && sec->sec_type =3D=3D SFRAME_KERNEL)
> > +                     continue;
> >               if (ret)
> >                       return ret;
> >
> Thanks and regards,
> Jens
> --
> Jens Remus
> Linux on Z Development (D3303)
> jremus@de.ibm.com / jremus@linux.ibm.com
>
> IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsra=
ts: Wolfgang Wendt; Gesch=C3=A4ftsf=C3=BChrung: David Faller; Sitz der Gese=
llschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
> IBM Data Privacy Statement: https://www.ibm.com/privacy/
>

Thanks,
Dylan

