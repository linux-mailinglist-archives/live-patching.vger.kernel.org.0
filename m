Return-Path: <live-patching+bounces-1303-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D83A6982E
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 19:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E3D8A5254
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 18:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121D52139B0;
	Wed, 19 Mar 2025 18:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFicFEtP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12350211A24
	for <live-patching@vger.kernel.org>; Wed, 19 Mar 2025 18:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742409483; cv=none; b=A8xmwVweursrTES4sUjGN72J4t2GFkdsNBWdblH77vm75bor+GaN5wFto5wl8MIlYDb5hbNduuZakj1svNGk2sxDjzu2ZorAR72u1kwvLiHqza8KLYIe9bXMwKJ4xmkwEY0m76T6oaWa7l8rCHfTdEvu4PkWzwJkxvyhDObllFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742409483; c=relaxed/simple;
	bh=1u54O193vNJ9UJyCPmT1aouN0YpCt/ylitFLEE8Ne8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZV842SCxUVmSQIGrFFv1yxx7RvBVBNEmCcWmaRhDpsadG4FI4UsUkR7TCYIXkOUA/xMO4PxVVP+fL8LJYUQjQHhYTMO+8CrrFO4RoS3tVMcXbUaOEWW/d4RdDNPW2BgpgisV6Ecxf0ZgMG19SlCUdjh+xaTKahQadpFhhJKjMdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CFicFEtP; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2c2c24379a1so5445552fac.2
        for <live-patching@vger.kernel.org>; Wed, 19 Mar 2025 11:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742409479; x=1743014279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zsvBxlf2VOaZb8vxBRnigpz+ulSEZ9VYrnq1SuZdcic=;
        b=CFicFEtPCa7KztCmw1QIrES4AYbG3G3aODJ113DJ5LufSNaqaOnqZKzfjAm6VwWjVP
         aA1Yp6WPPo9Xfsp4GfN6KtmeKcJY0sETUgVV2x5XaX0TIk5zkrMqfLynDuxB3P1C2GE1
         14AXd4pGAs4a+es7uWMVdTvpvRASUFeH9TAWiYiJPOhcvZp6+O3B3/XMIZJrQe+UTAWw
         tmoE/eprP6Vi82OGxv4NwgjrfQ/2rzh3W38b9QLb7IBoI11/K6W3ydF9YZ4L+7Fa09zI
         Sy00EYHbk5GYB9cITHC0UeeYbxcwd9cwfm1x972uva94m0qqUWgsKzU5XyjisXEB+Wk4
         0P6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742409479; x=1743014279;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zsvBxlf2VOaZb8vxBRnigpz+ulSEZ9VYrnq1SuZdcic=;
        b=ciDK++FnMam2mMviDufyZdGj8ReGpDDlUrxbi5TRHIv5NzNAdnxRTCDqebU5Ngn+a6
         UsJHb50g5CdaFvNEW7R2WbHELmdvTMc1a+S3L2VfAn5a96lA1kkmaVRkybOWAzfdR8o8
         +D0DQCF8pVQ+jpDeLR5aXgbYXdnykSuzEA+zKTKEaxUut5OYobhsqmc4oVQWYBDklt7E
         K8MWs0ha78Xv3fhp4/iN7Mq2TiT4eTef5thwB0a+fFEXuRsuL/oCAv5SqmfYrbQwJ+ZF
         AqZHfwBbMlBWgB8y3x6aeVFcV9W9v+Uozg7w74NkwPBZZAalWRhM+Gj5tMBbAA+dETg5
         MSbw==
X-Forwarded-Encrypted: i=1; AJvYcCXj+d2UP1JYeeknh4EjI71Vzh+aqLYOp7XHp3qdCGEufMyQjwuWrMpNDZGSfX34ZeB5XUj6vFc3J3ECTFE3@vger.kernel.org
X-Gm-Message-State: AOJu0Yzms30bd4cIFFG+nrwTcsGY6mB+YB99yqu+mywltQ0XrtRW+/Pp
	SyFq9Fn3NdYdCfecvaIeajnSNTIoR7cZDF8OPA0AG3OzBeaWiq8vtu7hT7tGm7rxHJUIz0cdpw=
	=
X-Google-Smtp-Source: AGHT+IEBFA4Sa9YRWk85bQR5JAziUVGfY3Rr0Wgmbdq2OL7Uy5LWKzyqkOQ+Gg3mIXPA8ssbkLAA0pQ5ug==
X-Received: from oacpy22.prod.google.com ([2002:a05:6871:e416:b0:2bc:6860:2684])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:8984:b0:2bc:8c86:ea31
 with SMTP id 586e51a60fabf-2c762fc74d6mr174282fac.20.1742409479208; Wed, 19
 Mar 2025 11:37:59 -0700 (PDT)
Date: Wed, 19 Mar 2025 18:37:56 +0000
In-Reply-To: <ifqn5txrr25ffky7lxtnjtb4b2gekq5jy4fmbiwtwfvofb4wgw@py7v7xpzaqxa>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ifqn5txrr25ffky7lxtnjtb4b2gekq5jy4fmbiwtwfvofb4wgw@py7v7xpzaqxa>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250319183757.404779-1-wnliu@google.com>
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
From: Weinan Liu <wnliu@google.com>
To: jpoimboe@kernel.org
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com, 
	kernel-team@meta.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org, 
	live-patching@vger.kernel.org, mark.rutland@arm.com, peterz@infradead.org, 
	puranjay@kernel.org, roman.gushchin@linux.dev, rostedt@goodmis.org, 
	song@kernel.org, will@kernel.org, wnliu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 10:39=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Tue, Mar 18, 2025 at 08:58:52PM -0700, Song Liu wrote:
> > On a closer look, I think we also need some logic in unwind_find_stack(=
)
> > so that we can see when the unwinder hits the exception boundary. For
> > this reason, we may still need unwind_state.unreliable. I will look int=
o
> > fixing this and send v2.
>
> Isn't that what FRAME_META_TYPE_PT_REGS is for?
>
> Maybe it can just tell kunwind_stack_walk() to set a bit in
> kunwind_state which tells kunwind_next_frame_record_meta() to quit the
> unwind early for the FRAME_META_TYPE_PT_REGS case. =C2=A0That also has th=
e
> benefit of stopping the unwind as soon as the exception is encounterd.
>

After reviewing the code flow, it seems like we should treat all -EINVALID
cases or `FRAME_META_TYPE_PT_REGS` cases as unreliable unwinds.

Would a simplification like the one below work?
Or we can return a special value for success cases in kunwind_next_regs_pc(=
)=20

```
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.=
c
index 69d0567a0c38..0eb69fa6161a 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -296,7 +296,8 @@ do_kunwind(struct kunwind_state *state, kunwind_consume=
_fn consume_state,
 		if (!consume_state(state, cookie))
 			break;
 		ret =3D kunwind_next(state);
-		if (ret < 0)
+		if (ret < 0 || state->source =3D=3D KUNWIND_SOURCE_REGS_PC)
+			state->common.unreliable =3D true;
 			break;
 	}
 }
```

--
Weinan

