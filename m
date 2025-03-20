Return-Path: <live-patching+bounces-1313-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE8CA6AC5D
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 18:46:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 294863B0606
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 17:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724A12236FC;
	Thu, 20 Mar 2025 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mm3G/HLm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33281E3772
	for <live-patching@vger.kernel.org>; Thu, 20 Mar 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742492806; cv=none; b=hV0HkHK0qa5SQyYoF11aAtb1Uyk9rAqKeRwW/Do15RPjpldo8CBoYtOQpeApuGynbAIluT6pOhSS3UakP198v4+g0oBzkY1h8qf/y7i8PJJD6GEHYb3Dcs96FmiTPTJBq7kQmEt9xjKOFPGKShtthh/a0biZATYy+Elz7x6qMbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742492806; c=relaxed/simple;
	bh=gGkHIctrglz/x9mJyu8j4/TTt+kOTJGYHX62Xb6+X5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GTxYHSYJvLFDl6C4f64+ovimR5qdyl9zBGn8IM+VJY7tOpbpgC+GPTuaL/E7/BVlMYMgr07Kc+N5oyjRHzM4tGH/ZWp7qVoqFMhUnjWgATTlK59I7XP7vmeEh4CoHK5DeBAtpWhzfLlhxG85SNzmzwrHRo+fyjHUFlHZ7lqcFV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mm3G/HLm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-224192ff68bso13168245ad.1
        for <live-patching@vger.kernel.org>; Thu, 20 Mar 2025 10:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742492804; x=1743097604; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C8sWmgtXc9A8SS+LZhHtZUXAexu8GgTmOedRrg1dhsA=;
        b=Mm3G/HLmlEbyXaYf+bymb2so+kLmnoTzJNCbYQBMJx63ptNsDhuzIjeqKLViLQfccj
         HdB6HZTVkG810qM+6vt5U9qpUz7mocbYOy/FnRSKitG+sEtLnml+ZVqLV0k+5ofFTjwI
         krKlCPj2GPci43DvHxRt7JQ2TxYQtbTI7od/DQGJX08SvYV0y8im8Gpr53OafuBxgixI
         Ao60A95+clA3l7LLVXA7+uokY4PI90Brj0laK2SGWyTMJFFI+k4qXBjfx3qjUhfmnDPZ
         8yMCm9nAixU/J4NnpLtv6EAldzAv1qgWpMtMS53SOGohOJMSA53+6ewUVqKFIoMRkste
         9CrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742492804; x=1743097604;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C8sWmgtXc9A8SS+LZhHtZUXAexu8GgTmOedRrg1dhsA=;
        b=YXcemE23LU7tfTtqryqHLQhPVk8mRB3fZAASfVuyaikDnp4+SYHmwhmJlU0wZjucgs
         e9l3bT4bVl3oyIo2SNT21JN7FQEqujbQKW6gY0xnrGltpWT3tYshYMhariN/IY0olDQp
         Xga78MasaeToA5cG8WLEnChNQpDI3qMJ2gCg+a32pwCUP4TdWjeSWYaIEj73bZ8SdM7q
         FUP0CM4E4P1yAeC/ilX4LjS+wpzpVOIwz/RLWnRlMmAZtP+mqqahSP3VZimpa+4vxHt+
         JrqzETLbRqMAju7b3myR350D9VhjP6YG3+aq3kE3hJ1l2rZwTMK9aQljGBWCe7jSBs70
         t25g==
X-Forwarded-Encrypted: i=1; AJvYcCWWk5ok6N4UFZNlcVsjfkKZ3ryUGszaXZCA9RxD+vqszt4o73MSOUK3cOkQd6hzudfU52ZFDpomrIVqt1c/@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8RrCPyvsUa1EOGA6CdzT9trXphW+/JsioYip0IJzImqb+w00C
	AquShT+EbBAsk/jR1vUcMeD6r+FgpCuLt87BfnzgLMKN3gTeq/Z3kQ/1OH+mwntL501Nn6Brbg=
	=
X-Google-Smtp-Source: AGHT+IGkcvsUd+T1mc9VlLct3/yS/hr+HeuaSZ94iAFaq0agza5SWuSHmNHqalPgRdwW9LY8R0G3yzT4RA==
X-Received: from pfbcg19.prod.google.com ([2002:a05:6a00:2913:b0:732:7e28:8f7d])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3991:b0:732:535d:bb55
 with SMTP id d2e1a72fcca58-73905966850mr512059b3a.4.1742492804271; Thu, 20
 Mar 2025 10:46:44 -0700 (PDT)
Date: Thu, 20 Mar 2025 17:46:41 +0000
In-Reply-To: <20250320171559.3423224-2-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320171559.3423224-2-song@kernel.org>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250320174642.855602-1-wnliu@google.com>
Subject: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
From: Weinan Liu <wnliu@google.com>
To: song@kernel.org
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com, 
	jpoimboe@kernel.org, kernel-team@meta.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	mark.rutland@arm.com, peterz@infradead.org, puranjay@kernel.org, 
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org, 
	wnliu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 10:16=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
>  static __always_inline void
> @@ -230,8 +231,26 @@ kunwind_next_frame_record(struct kunwind_state *stat=
e)
>         new_fp =3D READ_ONCE(record->fp);
>         new_pc =3D READ_ONCE(record->lr);
>
> -       if (!new_fp && !new_pc)
> -               return kunwind_next_frame_record_meta(state);
> +       if (!new_fp && !new_pc) {
> +               int ret;
> +
> +               ret =3D kunwind_next_frame_record_meta(state);

The exception case kunwind_next_regs_pc() will return 0 when unwind success=
.
Should we return a different value for the success case of kunwind_next_reg=
s_pc()?


> +               if (ret < 0) {
> +                       /*
> +                        * This covers two different conditions:
> +                        *  1. ret =3D=3D -ENOENT, unwinding is done.
> +                        *  2. ret =3D=3D -EINVAL, unwinding hit error.
> +                        */
> +                       return ret;
> +               }
> +               /*
> +                * Searching across exception boundaries. The stack is no=
w
> +                * unreliable.
> +                */
> +               if (state->end_on_unreliable)
> +                       return -EINVAL;
> +               return 0;
> +       }


