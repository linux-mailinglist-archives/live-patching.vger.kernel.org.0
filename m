Return-Path: <live-patching+bounces-2851-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uDcsL4YGDGodUAUAu9opvQ
	(envelope-from <live-patching+bounces-2851-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:43:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F29578451
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CFD6D30386DE
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987E73815E4;
	Tue, 19 May 2026 06:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IyX5EIYx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0231B388368
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779172188; cv=pass; b=qopfxHiJ/mssMTo8U81sa3XRPNoo5ZsaHlkUYjX4QuEtYhYDu/Uxl8ygeveiZn85Rulh0+KjFBlu+WnYWYEgdFBdVVbLeRMHVsAa2RZhQqbUGMpXUFy/F59f5Na5MB+ghQ9hn8pzEMcS1jWJ6SCDGU1F2bg3uZaOCjYRUBXph0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779172188; c=relaxed/simple;
	bh=1AkCjI88uYaqNn1vQTZs5qNoStzybQf/9m1rH+SGz+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtIsi3K4oc0nY+QOuBzMrQJ1ShKhifzTVKmVUBtgg4xFSKUortOxZRm9JiJb5mzPSDMRCN220MMyFn7CEXTBSsar02TU8HPdSeA5TBkUH7Aq53l0lywz3wjouStnkJamZLF788Nm+PuIQ8rkvr1lnceHx0KwrFCsW5B4nAAiy0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IyX5EIYx; arc=pass smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-95d0476492bso2123734241.2
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:29:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779172186; cv=none;
        d=google.com; s=arc-20240605;
        b=a+7fzZVCurquod5R/V6fonZDRfdM3HL1DBxJp0g+bd8k6hOu56RN550IX/NwABbwsD
         E+NrRwctYtXPzONSlHJM22UgoqxlI1i8LTYA30uJr8CvcuTBtvMgewAwNVvw/tarmaSY
         n+sBf2YJ8rMpyL7zgmALtZjqaOedQ72clPcbM9l6IUQFdnZYZUU8QIuLPjtLX+wyrMLG
         yJBu76jI7+gPiBNkcEMaFp1Xo6RhMFt7s89WeCYKLN2iepwXH9JJfcEvQeVvo89E1Ccl
         O2G72a3NvmP/pAFMyTq0vRp9Se6tt0Tv/NtURasMTV7Uc0MV/9RUagDDanpLXONbsAJF
         L7Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KOIDrkK5xvT4oUVA/rPFV65xHWjcWcJWlBhzkHkilNc=;
        fh=MiOyLzevrZTWGuBpt+CpRc2bKtbSGWlDO2QU3m1s5Tg=;
        b=kPPrVgdIwUQitOInP1wokgJUpzjcjxVxnw7VwQXNFHeBqT6r3WinfGNtpq3oc7K/Qw
         1DEdMyc8n+wFsrNt7mytkw8jMQJodc+rrlxHqFeKi/CUjbs4V9aN8bE0guysM0Ay8h/J
         k5Nx94Lt9BUK2wy5+MKqzrRAXKZAjkdmT/R0+jdGYYa08jiCQxrBoxi0qBmGsQ7wDjZf
         w+dtu4infxZmmv0z/tQfODI/y7cwVQ8AaZCKyLnpUPw+QS+pp4G4fuWFtJq5+jWNnOmH
         CO5G8M92dC0cWDPBRK7pd70YEyVH/+DLrVoPxLYyoGH/63+GD02dxC7GNixVIWI9QbbR
         BONA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779172186; x=1779776986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOIDrkK5xvT4oUVA/rPFV65xHWjcWcJWlBhzkHkilNc=;
        b=IyX5EIYxw1QXClbkFcfZVDtFr0aOIaUZiizZm0JdoOeDk5cjDKzIPjiaFCsaWelA3K
         dfZe1MGCRBSVbmzVLOXSjaSJDeidi8UfDMABpZp3h5PPZsM+tshhfBiRoDB/VISEeIKY
         IKS/J1OFSRRKj7GeRn6dAACq4mMVaSvrVdR20EkYMw4BeiL+7ck5I5I/Wo9kkpAwfaIV
         4UCZIFGnH/ig101oxjCBYAKksfNgeqDaVgGwpo2lsqi7SbMKtAhi33wljb6+eeqAL8Zy
         try/nDIE42g3IHChHNLAiWJ42NjaX3KGuQQAtAGl5OzGGMnjEqiuWUStczATGx3Im2Il
         9HCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779172186; x=1779776986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KOIDrkK5xvT4oUVA/rPFV65xHWjcWcJWlBhzkHkilNc=;
        b=cAwgTWNmPiH5i6DrfNuLsa+WCkxVC7Nh3ZpzklAjJ9D1hirUzzW8WpqaCZW+96jL+r
         Jxlw5CGqOptRK+1AUKaDBrYcTGXm1wdpU98eZwEH/+rT/MRdHQF1H5xQWCQfCIm/ZYb6
         CdUC+kkdcnaqlaObIg4LPEUBEdeN8rmM2h+cAd6bfMFhhXDJ9Deo9/0pm54mnLukWHwY
         0wxYdvzLuq9LCQZmHbtdpgj8qwW0gu0otX+ZsOTaATFhvgVXLhRy6Ny+7Y45pvjQEeyV
         Z5iHsZPjckYGkFGFdsqHH18hsWuGjIVtvrNY69WpGPVevJjPCYCd+UgAbPZWHHeE2knY
         /SSw==
X-Forwarded-Encrypted: i=1; AFNElJ9gE2Z95J/0Lgj1wY4hTu2LQpIlhiaR9AyT5sbiM+/faJd4bIIderwNbnZiYd5ZhMqqs/Bvywi6tg/MZDI4@vger.kernel.org
X-Gm-Message-State: AOJu0YzwtNXbkJkFDIplYyc958st/U0/foz26f7Kd4kMlTb84b3XomJv
	xcaCKZOR75t5/9BVv9HHCosOuCBYcjFVmsMbIA4BI+Uf5sB9E8AtSTfSnPg0OLZF+wZSkyJVrqe
	8+VYqzxuNAyiQrqDfI+PEGhQE5N1EGdYSURY6qByN
X-Gm-Gg: Acq92OGaAYm3+YUt4V7+Xv3kQ11fnLFYIiofD9NDilyQGvWGD7pbR6uYc+VR9N+kLhI
	OfIkwSFXcgvft1pftRsMe3LzamjWUdCi8qqYTlfxxHyx1NU9nwEnVfm3mZwie66bcLpJGMhNjBo
	y58CslNqNhipNrBlNlOstvVOi5ciYJKGG6hEVj4+VxYQFj53+CF3ck+R9AvDliM7jTWuZ/yVpfW
	Apyn95bTzxoDZ5++qqxfAquFdQxw8umh2tdoRoVMcN2sTM2yb3jVuNU8Ct3mYFN7SrVjbX2fgP4
	iPmMzOShrkfA7rsOtw==
X-Received: by 2002:a05:6102:8029:b0:632:d8d5:2908 with SMTP id
 ada2fe7eead31-63a3fb923edmr8764523137.26.1779172185387; Mon, 18 May 2026
 23:29:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-9-dylanbhatch@google.com> <afTYzAF_x41pyilu@J2N7QTR9R3>
In-Reply-To: <afTYzAF_x41pyilu@J2N7QTR9R3>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 18 May 2026 23:29:34 -0700
X-Gm-Features: AVHnY4J27tyQp05kCz-lzjHHD3sgwRY6rb9HPySm6bAi_CgKxNVRppKxUDePNlg
Message-ID: <CADBMgpxZ+Lh7uvPXT63XvKfxe_OpcqGN2EZAQ3PZiWvLiv3Cjg@mail.gmail.com>
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt frames
To: Mark Rutland <mark.rutland@arm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2851-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,mail.gmail.com:mid,arm.com:email]
X-Rspamd-Queue-Id: D2F29578451
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Mark,

I'm sending a v6 shortly that should address all/most of your
feedback, but I wanted to circle back on a question you had:

On Fri, May 1, 2026 at 9:46=E2=80=AFAM Mark Rutland <mark.rutland@arm.com> =
wrote:
> > +     /*
> > +      * Consume RA and FP from the stack. The frame record puts FP at =
a lower
> > +      * address than RA, so we always read FP first.
> > +      */
> > +     if (frame.fp.rule & UNWIND_RULE_DEREF &&
> > +         !get_word(&state->common, &fp))
> > +             return -EINVAL;
>
> Why is this get_word() rather than get_consume_word()?

I use get_word() here because get_consume_word(), in calling
unwind_consume_stack() under the hood, consumes the stack up to the
given address+size such that another unwind step cannot consume it
again. If the subsequent call to get_consume_word() fails, the stack
needs to be in a state such that we can fall back on a frame pointer
unwind. But if we were to use get_consume_word() here, the fallback
call to kunwind_next_frame_record() would not be able to consume the
FP from the stack because it would already have been consumed by the
failed call to unwind_next_frame_sframe().

By only calling get_consume_word() on the RA at the end, we defer
making any changes to the underlying unwind state stack until we are
sure the SFrame unwind step will succeed.

>
> > +
> > +     if (frame.ra.rule & UNWIND_RULE_DEREF &&
> > +         get_consume_word(&state->common, &ra))
> > +             return -EINVAL;
> > +
> > +     state->common.pc =3D ra;
> > +     state->common.sp =3D cfa;

Please let me know if this reasoning seems sound.

Thanks,
Dylan

