Return-Path: <live-patching+bounces-1146-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0074BA2E680
	for <lists+live-patching@lfdr.de>; Mon, 10 Feb 2025 09:31:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9BC7188CDCF
	for <lists+live-patching@lfdr.de>; Mon, 10 Feb 2025 08:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3A41C1F13;
	Mon, 10 Feb 2025 08:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HBdFdtZ6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112261BEF85
	for <live-patching@vger.kernel.org>; Mon, 10 Feb 2025 08:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739176222; cv=none; b=S/bpv/HNhVr/jdEKJjNW4c99HuI/bavX6nj3HRGEqZHgVVUfJt52n3gGUIx6e4FETyJsG6fUob9WFkGmA+Bsw5vvqueNjJmLbn1LtL5QHrRctlZLndt3yV1dKemTbsMEVzkugYK9y79C3XfhnEcB/qWZ4ZvOTA8lQdhhI2uxg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739176222; c=relaxed/simple;
	bh=PPmmV6mrjHp+lAp5KhBgmJc4ilN/3JaEJWAOyFrLPSw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YpgxtxZcBFt28p1x20mNyXYIHBlCvKHfDFy4TXQvIZpL4ny9/grS5v4x4UVs7jz+VMCZddeibYujj0mt228Ju6dY3AcuqFXRIwEKxE0XZ+pm5T3F3CfHiyiXB0yk3x0NDwmSOodQq+NKKQP4AaQjppNohxhUKedIUA5dEP6ajVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HBdFdtZ6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa32e4044bso5124727a91.0
        for <live-patching@vger.kernel.org>; Mon, 10 Feb 2025 00:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739176219; x=1739781019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PPmmV6mrjHp+lAp5KhBgmJc4ilN/3JaEJWAOyFrLPSw=;
        b=HBdFdtZ6JSHjJJd3i3oiGM5RcWOB/3gKKGkpOXMp9hhM4TSpwwSuXJ0x16fU0X7Sw1
         k3IFOEiaOnlbaWcIh0qzts39EMozAwzlsCFs9ci9VVFIerlbmki9s5rU2DALc75ooGrm
         ORZQqARub0fhNvZpO8sAC1IXXzoDkxW9Lh9dQ0PGSc7BPGHukWSoHmLM9Qm2dy+RTzQ+
         mh7R9RCjeOSmwqNaNE0x6RAPnn0XS1Gp3S/daMZdGYbLh1QMzAnsr5HJktAVHM174LrL
         h4hPXDlxwfC4svcCWJ54qZQBh9WZf3MufmeFmTGfTnMOydT1FvfTBb4wwJ5/1MLQhv9u
         mM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739176219; x=1739781019;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PPmmV6mrjHp+lAp5KhBgmJc4ilN/3JaEJWAOyFrLPSw=;
        b=DjyIocnfo4iCWlk7SZrPzebS+zpqGLJfxHWiN/cXw58YZMPuvPvUR7CwizvOqa6PxS
         QyRcgd/YYcuQr4qF1oEKWo3QJUu7pBrYyTeC+gwkF0HCAErA4xw+kq2AhBN+hmiua0CP
         5f+7dPW6R6aeWkAZUdOzHcWGnxLX/uHgPqqcrCiItHH5RKOVcg8YCfDGUvAYPGsau5A3
         l7wFF/EFuHibvXVYgTdZvp4OFnvQDAiAwts0TXfyrSwdZZ0rQt+kEHzvUPrpVi68P3Q+
         l+g7aEd2m8ZE8D7AM5iu9UjMwPia4GlOeHfh7p1NjmB2alSKZpWAIMjOGrQPyqgftqT/
         yH/A==
X-Forwarded-Encrypted: i=1; AJvYcCUmtLy7OmAjtqhR8yh8nqmWn5GEI99y/XCeVLQIFqgSud3sg1+7xrfmqyk/tx6OjP5JaAveGoxv56T8QS+k@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8yd8bkjwxL+50ynpE1ELsZkAx9HrvYnXZ68XWGinJQK6eAAXN
	8j1LIxCZFSyyoINL20XN3TEiOf0ofhsofEEXyfxtynY+u1hwmdQLcw5c9LBGFWWWy/Tcx9pkvg=
	=
X-Google-Smtp-Source: AGHT+IEXo1lV682Dvui+xqTqQ9vsTUnOVO23WNyemCNciJ06wQPtgH2MGkCCmvZ/liuvldm8njt7IMjgAA==
X-Received: from pfbbi7.prod.google.com ([2002:a05:6a00:3107:b0:730:9499:1f46])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:850:b0:730:949d:2d3f
 with SMTP id d2e1a72fcca58-730949d3086mr2135669b3a.7.1739176219304; Mon, 10
 Feb 2025 00:30:19 -0800 (PST)
Date: Mon, 10 Feb 2025 08:30:15 +0000
In-Reply-To: <mb61pikpm3q76.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <mb61pikpm3q76.fsf@kernel.org>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250210083017.280937-1-wnliu@google.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Weinan Liu <wnliu@google.com>
To: puranjay@kernel.org
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com, 
	jpoimboe@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org, 
	live-patching@vger.kernel.org, mark.rutland@arm.com, peterz@infradead.org, 
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org, 
	wnliu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 4:16=E2=80=AFAM Puranjay Mohan <puranjay@kernel.org>=
 wrote:
>
> Yes, I think we should, but others people could add more to this.
>=20
> I have been testing this series with Kpatch and created a PR that works
> with this unwinder: https://github.com/dynup/kpatch/pull/1439
>=20
> For the modules, I think we need per module sframe tables that are
> initialised when the module is loaded. And the unwinder should use the
> module specific table if the IP is in a module's code.
>=20
> Have you already started working on it? if not I would like to help and
> work on that.
>=20
> Thanks,
> Puranjay

Thanks for updating the arm64 kpatch PR so quickly.
So we can use kpatch to test this proposal.

I already have a WIP patch to add sframe support to the kernel module.
However, it is not yet working. I had trouble unwinding frames for the=20
kernel module using the current algorithm.

Indu has likely identified the issue and will be addressing it from the
toolchain side.

https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666

