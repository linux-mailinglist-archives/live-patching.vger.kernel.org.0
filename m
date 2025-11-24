Return-Path: <live-patching+bounces-1876-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C04BC81D91
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 18:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCF433A1D00
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 17:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76853F9C0;
	Mon, 24 Nov 2025 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6CwbMFm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E3A18A6A7
	for <live-patching@vger.kernel.org>; Mon, 24 Nov 2025 17:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004514; cv=none; b=PUJCkWNLD1l7u5xZDX4cqmF9xIHIB/PC2TL8JmvfzPVR3Q1YwRX35Z9tx1WOIrg5y5a6nwswkxtrjyRBaBPLBtFGGm/0NAw50WGpead4H3FB63UfubG9V+LadzFZoBrwIqxsT9Ax5b8Loe5gXSEhuTUJ2JNrZbRd8/M3Z2TFFyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004514; c=relaxed/simple;
	bh=Q+/DyZjLvOXPct7tmBqaRGe93isBz1eaNThEZqONNBg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nO5bWXj279EMUywntNwOS32j4UT94zlNLtI4Fz+iF7Cw2N9xYZKU+uRHn/ZXPd6mN7JsUCmbL8kV/EgC3Tddks2P1dSoiMgkxw3FLJl6lkRzoJlSJzL5PLvvZ8TBqxQWB7r4VQ2gh5dfrjfHrxNpepsBZBmLItuOjVzry/hflOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6CwbMFm; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b32a5494dso2436750f8f.2
        for <live-patching@vger.kernel.org>; Mon, 24 Nov 2025 09:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764004511; x=1764609311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xf0R6pgOXPMXXlrBatSlZLsanZIehujUAI56eNnYOFI=;
        b=j6CwbMFmvUkrejn1t00An/fHZQBzs1m58wHKDmA9m+gxcNz2NcyVZfQO07VJaE67JV
         kHX3OB0HfzSWLmAKPbZXlfo/CYNuxqL71SVSJfhWHJfHQcRF1GWjEFIM/NdRm+fQWqh/
         DpOMIu3oLaotfiCPRCGp7O1Ja4gx8sGZ3/T4WsBk2djl2dPoiocjDbe4rO1MeHHEli8a
         j59ZaypikLjf3D0tvGqd/IORSB/vQjZUhqXKqvev8F3+KdrgAj7giCQQstbjgRuYQ9Es
         3UMUEXGRWhUa12samq0pyXOFGt9LZCb1+tnf56+w4beJCYbMUOgleXKzRmkkoiI5spNH
         xwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764004511; x=1764609311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xf0R6pgOXPMXXlrBatSlZLsanZIehujUAI56eNnYOFI=;
        b=rSFe1YOjkwUvlpDETqJzMoJtWHSN/p0LMJvh9m2ejh+gYiHicSHZgJLnsRxMA5OiJ9
         vuX7ZCr9f1PqX9ZbBDnpKiNoYjcjMlEId8z8BQ3xOuxK4diERvEXHqkMGtivgMwBrKh3
         DE2AEM79OSSmNsqj/2bO3TlnOuQehhspNOtCCvLL3bPpfiSv2JsJox+AYJdHP16yD2Jg
         9x9bM7tt1C+sPHiY7xofp6imJ6NpbbWKxSm3Bf1eHTrJX5h54dT8jYBZkKYuFXI0+cV3
         W4Rf246+2zFRNydETlx7OUn8r9p5fN6EsMc8/83k+qUZpmDQGdySA5VrGoEJhEM6L7hD
         mwmw==
X-Forwarded-Encrypted: i=1; AJvYcCXtWaAa8MBxOGDQW1BfwpWT0jsIvWEIdEJuXMFexkOgO7koZlk30UU8buKgu1FBfucWP/lR6e+JURqcgiQb@vger.kernel.org
X-Gm-Message-State: AOJu0YyMeEtQtski6a3LZRkSGiCukXw8zLSAVUzS2qxPHpzxT7ChnCLP
	XscvLwIfzGv2MwzZjIKqQ3P4bAo8XBTy9GcK8h2JgGZb4VEUg1CmrL5DnWlvJh2binGDZTNLyv5
	6skZm25sjRrLnVidGxo53pI2gbiOvJMpPA7xj
X-Gm-Gg: ASbGncvYpgRXzHHfTRy1I1t0LWBMRFsk2enkLcZgS8EBEiBb9reyrOc1snLQ85Y88gd
	ZKrG6pmnt8wDh0UF9U1Q470N540hNqzCh1XkUYvjyNH/OLvxIIgOuN4cltRlfKeDMHH+k9cLTcJ
	XZkS1e4PDaLeLj/i0Uu24O256NP3XTUp5IjNrXCf9CMKM15zn2yp6TFoMAjmKZ+0eTCJ7H2lgK5
	eros8syLoj0QEVIflcuaLNqsVOyZG712zGVGhatcxeom9I3XN9jqnoV2KBhtzNiexeBKsZTs8nM
	1L7n1j6gJzc=
X-Google-Smtp-Source: AGHT+IG3TQCF29k3/0oYfxapdRYF5ShpO49z+GSv5pNz/JHDiUd1ARlPgUy0GdJeiH1icTPuVTT1M6WZAWhtxA0ZJYg=
X-Received: by 2002:a05:6000:2601:b0:42b:3da6:6d32 with SMTP id
 ffacd0b85a97d-42cc1cf3bedmr11909705f8f.23.1764004510865; Mon, 24 Nov 2025
 09:15:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
 <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz> <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
In-Reply-To: <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 24 Nov 2025 09:14:59 -0800
X-Gm-Features: AWmQ_bkiKRGI6g0lyXxVEwqBqGMSF5stePJqiIL5GsG4k3OfAlcU5urtEOCg-mw
Message-ID: <CAADnVQLWD5-z6uajf=WzKj1J2V6+fc1wNBTzBJj3ufbskMEoPA@mail.gmail.com>
Subject: Re: BPF fentry/fexit trampolines stall livepatch stalls transition
 due to missing ORC unwind metadata
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>, Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, 
	bpf <bpf@vger.kernel.org>, live-patching@vger.kernel.org, 
	DL Linux Open Source Team <linux-open-source@crowdstrike.com>, Petr Mladek <pmladek@suse.com>, 
	Song Liu <song@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Raja Khan <raja.khan@crowdstrike.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 4:56=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
>
> Maybe we can take advantage of the fact that BPF uses frame pointers
> unconditionally, and avoid the complexity of "dynamic ORC" for now, by
> just having BPF keep track of where the frame pointer is valid (after
> the prologue, before the epilogue).

...
>                         EMIT1(0xC9);         /* leave */
> +                       bpf_prog->aux->ksym.fp_end =3D prog - temp;
> +
>                         emit_return(&prog, image + addrs[i - 1] + (prog -=
 temp));
>                         break;
>
> @@ -3299,6 +3304,8 @@ static int __arch_prepare_bpf_trampoline(struct bpf=
_tramp_image *im, void *rw_im
>         }
>         EMIT1(0x55);             /* push rbp */
>         EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> +       im->ksym.fp_start =3D prog - (u8 *)rw_image;
> +

Overall makes sense to me, but do you have to skip the prologue/epilogue ?
What happens if it's just bpf_ksym_find() ?
Only irq can interrupt this push/mov sequence and it uses a different irq s=
tack.

