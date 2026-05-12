Return-Path: <live-patching+bounces-2740-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHgDLBN+AmrCtgEAu9opvQ
	(envelope-from <live-patching+bounces-2740-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 03:10:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 237975180C6
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 03:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1FA83015E09
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 01:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AB82472AE;
	Tue, 12 May 2026 01:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DstyCxTn"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B0A245012
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 01:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778548241; cv=pass; b=Y9wBSHCWDyalPujS7mtXdntmnpqVn/bpZKQy07K0Wm5qlYYSU3Y76dDDQPjT0CaQnFD/MJM4W+qqliuohmCAdUvmLR3hRZudSQIVWnnHWiSLnDJW7f1l4vVuoUkqDpx0Ydcy1XWh0pcF6CiZSWzw52Dz0U17/Dos6MJEqe5uvwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778548241; c=relaxed/simple;
	bh=U/mI9EuKhOx9MnkQJ6UYntZNQBhTfsEjgUNsrlOPxmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xk3Q9uBjjpemnDDB61pzFTWWy16BZG96kBUZPgYcYb3EMNfv3KiizFM6WDni9kd+LI0mleKRjuTv1AfCatHyAxts3dmUph48P0KJFUGd+NCUP0+EMYF/Lu3u/hKn1mfdevii7bu8G9zQ1qpApRpQxes/yXkjblWu1nYwUVIstZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DstyCxTn; arc=pass smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5752b279662so1570848e0c.2
        for <live-patching@vger.kernel.org>; Mon, 11 May 2026 18:10:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778548239; cv=none;
        d=google.com; s=arc-20240605;
        b=k/MehuM1ArRWlEEL3/MZL7H5yvOdMzwe1GdmaAy0CbrW5B86arCgS9H+etCbFSueEc
         vBY7+8ozUrppxye3FvFYiEO6ySOTZXjxg4TLSiFJA4hTT+PsClFnGE4hzpnXYPQfzAF8
         X+8PdCam0mWRRPwkmEhEJdHF0YLxsYmACh2kIipqlhkCfKPXydnKS0rc+jlNO41HYFM1
         EV8Vi6ZHxnN9FZV6IxHODJNj5UD6L6TsatYoZG5gJbUPbN327uQx0SCQHb81SBSzcf5w
         XtKEnOsKugVRj1ZD7xrLOGjniBfkjWytNOvldF3uE/CMfmYFO2VDTGY4ZF1kXiESKpfP
         3Bqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d2L2S9MvUFFvpzZ7zF7cqwq66hTG1YCAiCG+LuOM55o=;
        fh=0OB6KIhgip4+sonqHhRIIwWNEbbT9hget7hdQV+ZpVc=;
        b=HAEmiSju8NzuJijbgssid9RrI6Dglto1clvzW10jyplPM5PvO1ze3jWkE32UGiJ+cD
         g2C+5mcdQ7fHO7ZFp9B/I1sMn6MStI/5//ltBGEFcs/i+NQnQwcTQu2JiBW+oZxPYfoA
         RIyLHo/4VrTQCYPY84uG+taGRWX56xGKWx6CwaFWheNBsDUh7WRZ+79X63XSaniTJphs
         oP6/Jftp+84KD335KX9cXRIPG7B9LAhVzREJxRAwSM6SLKuF7Y+x/NEMuPsbekqLIrr4
         n5nOKsx3iW2WAJm5BrWPDa5vmO4rZSCANbG5uKhqdmkFhsC6UiWAlL4qJL8HgvyuqLdd
         W2zA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778548239; x=1779153039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2L2S9MvUFFvpzZ7zF7cqwq66hTG1YCAiCG+LuOM55o=;
        b=DstyCxTnOgx4gSA0TQYq65WxhwxOmxYQtSL3U2j0e3kplx0pCCSE0I7x8AiurhxNDx
         Ecn62m7f5Ex9cPNXUcx4DrQsxYvxYHhDTjTpARXEN/0m3ZJKMRPbxRenkxzoVoHr80S8
         Zss2QPQOfXD+EbN3kLdoEA+lPlkSkF01FxgsikIC7iScb2XKWvPTMn1I3qQxa5lmQe6e
         viYAQ7Xw3p0+zzvPbqIVNWOEuS96QE6TNt8TaMd09vQ0I+HdI+fIiMpp/+lOFaIH8F2B
         lMq9rx+UsMTHLKPi/bm5dyDjEG2AA31U9p3k4+aniA7QSTlntSWB/bwoqoRP9SVvpX7V
         5HqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778548239; x=1779153039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d2L2S9MvUFFvpzZ7zF7cqwq66hTG1YCAiCG+LuOM55o=;
        b=eEEl34zK+ax9bINDMRgSbl8TK7DJCxbZHe/RbvYqqV6fZBip2FIbzFd/KjIF13VWKx
         IJMDJh8N2bugX1JRbdHdlZcOVpBGMCxM/uaYGinMDK5ACy3hUP9WIVk/UKthsJoqboM9
         KiD5blWvG+7xhCbCLHS4uieT3oyXZwfCuSf3piVPKR+YW01Cs6StBdLSg06jV0vvZ55W
         vVv4bKhLTw6j1qdxMsMXGX5XiUjt0k1lQrxcaefiprP7+TZGTHBXCZiDhPGalzCSqmnB
         5cF4lzKqD034pn0bLsXlOfE3YxyCg01brx8V/biOKg1nbqyd+14QjJNgP47PMts0W4hW
         On/Q==
X-Forwarded-Encrypted: i=1; AFNElJ9WXNonaSQJepLuKfuXT/kGAI3L1vSZu3Gtac8PhbbWypHMXpFpA6tJfviwNirCQ1OswQuqdlWKpsMu2h2B@vger.kernel.org
X-Gm-Message-State: AOJu0YwIdDgjS2kStWo5ZkT9kdS7k/VH0ZtXC3D3GqYJ/TC4JWnCmz9B
	urJ0bWV1ZFdCfwpKJJ7RD+oT6waV+jVU7TIKYITZkXpz1Au+pbAvOD/6Pgn5vctXKWn11Y26gyq
	8eRXspOg7+Tg+lSM/JXlHcZfMV1R7jAKPtAvOa8RE
X-Gm-Gg: Acq92OHp5zC63dd7fkt4COhrhRempWJFlxhnHGtsAHd9ls2X1F+YdfSMHGIhurwkS1h
	O9REtaYHvlGevjyQHdggZFm3cR3mm14bW9uZc9sPxqSRqgU60kZvh0zSZWT6bOywixjyE5cUgS0
	idRo+pcFByuoLPEGmZhI1Tocp/chl4VOsJPYFoM1Ud3g6J2t3BRF0HPQjR2AGf36xECnlcPVOK7
	7MG4b3onqNFbeJMpARl9LWTPveeeBeDU4rbMFZYJI7pCAigcQDOeuLZSdfvqCj87UxBRJN04MpC
	aLFHXCHv9Tcelx4MYA==
X-Received: by 2002:a05:6102:2ad6:b0:611:6fef:90d with SMTP id
 ada2fe7eead31-630f92a41a6mr12795859137.31.1778548238405; Mon, 11 May 2026
 18:10:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com> <549d10b6-ba2b-4ae9-86ef-6157e13b6ee3@linux.ibm.com>
In-Reply-To: <549d10b6-ba2b-4ae9-86ef-6157e13b6ee3@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 11 May 2026 18:10:26 -0700
X-Gm-Features: AVHnY4K1Ilc6ZNSFBH-MtrSxiuvTeFABP2FASi4Xr4ffzUnpNsS3RxypEz1ND1s
Message-ID: <CADBMgpwDzrQU289fRXCRvSiCo3noOTy6=q8C58sLPrT_KO+=UQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] unwind, arm64: add sframe unwinder for kernel
To: Jens Remus <jremus@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>, 
	Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 237975180C6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2740-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Thu, Apr 30, 2026 at 3:11=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
> On 4/28/2026 8:36 PM, Dylan Hatch wrote:
> > Implement a generic kernel sframe-based [1] unwinder. The main goal is
> > to improve reliable stacktrace on arm64 by unwinding across exception
> > boundaries.
>
> Please add support to initialize the optional sframe unwinder debug
> information.  Either in the appropriate patches in this series or as a
> separate patch.

Sounds good, I'll add this in as a separate patch in the next version.

>
> Note that for the module case I wonder whether it would be preferable
> to somehow indicate that it is a module name in the string, e.g.
> "(<module-name>)" or "<module-name> (module)"?

I don't have a strong preference, though I agree it makes sense to
indicate that the section is from a module. For now I'll add the
parentheses "(<module-name>)".

>
> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
> --- a/kernel/unwind/sframe.c
> +++ b/kernel/unwind/sframe.c
> @@ -1028,6 +1028,8 @@ void __init init_sframe_table(void)
>         kernel_sfsec.text_start         =3D (unsigned long)_stext;
>         kernel_sfsec.text_end           =3D (unsigned long)_etext;
>
> +       dbg_init(&kernel_sfsec);
> +
>         if (WARN_ON(sframe_read_header(&kernel_sfsec)))
>                 return;
>         if (WARN_ON(sframe_validate_section(&kernel_sfsec)))
> @@ -1047,6 +1049,8 @@ void sframe_module_init(struct module *mod, void *s=
frame, size_t sframe_size,
>         sec->text_start   =3D (unsigned long)text;
>         sec->text_end     =3D (unsigned long)text + text_size;
>
> +       dbg_init(sec);
> +
>         if (WARN_ON(sframe_read_header(sec)))
>                 return;
>         if (WARN_ON(sframe_validate_section(sec)))
> diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
> --- a/kernel/unwind/sframe_debug.h
> +++ b/kernel/unwind/sframe_debug.h
> @@ -32,6 +32,18 @@ static inline void dbg_init(struct sframe_section *sec=
)
>         struct mm_struct *mm =3D current->mm;
>         struct vm_area_struct *vma;
>
> +       if (sec->sec_type =3D=3D SFRAME_KERNEL) {
> +               if (sec =3D=3D &kernel_sfsec) {
> +                       sec->filename =3D kstrdup("(vmlinux)", GFP_KERNEL=
);
> +               } else {
> +                       struct module *mod =3D container_of(sec, struct m=
odule,
> +                                                         arch.sframe_sec=
);
> +                       sec->filename =3D kstrdup(mod->name, GFP_KERNEL);
> +               }
> +
> +               return;
> +       }
> +
>         guard(mmap_read_lock)(mm);
>         vma =3D vma_lookup(mm, sec->sframe_start);
>         if (!vma)
>
> Regards,
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

Thanks for the suggestion,
Dylan

