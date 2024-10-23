Return-Path: <live-patching+bounces-752-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2879ACACB
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 15:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CA35B20CCC
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 13:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8646F1ADFEC;
	Wed, 23 Oct 2024 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khgt31IV"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D62714B94F;
	Wed, 23 Oct 2024 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689057; cv=none; b=W3eb/kavaWbU2k8PYPPBwU/aknU3J2AAatqDiQdorvzaDKgQEBRGWS0/1Xlspn8FKsD/sN54BKmuEeDr/jszCZkfLWUYh1PFUMz8V9/QhOjfXVUy+Q3p87Nv+W4fv8wXIQL+iJd0Ba+OgLl19v5zzVTnXgdezsICpXye8o+kmU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689057; c=relaxed/simple;
	bh=cBfmrlBSfEjkwWoQphvN1hCBGz3UX25x8xMEoPM2ncE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=olLfXtnIFF5nWD+1vB/rH6vuAewA3rIdnTCbDBLjZE9r8NcM/SFKTUuN+mak2+laDTYp/XqgAMNvlbQ6d7cNKWwx+lqe1psTLZAcCzDARfdz+Qz+XCF+Z1cUpQovzxP5fWXfujYSXb4VV8m/TWWn5OYaTqyp67a0ZiuOcejgKkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khgt31IV; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7eda47b7343so318832a12.0;
        Wed, 23 Oct 2024 06:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729689055; x=1730293855; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBfmrlBSfEjkwWoQphvN1hCBGz3UX25x8xMEoPM2ncE=;
        b=khgt31IVkIuIxpOw/XyBEumtGJCzr7cZ5aPyOgCsDHt0j2H200ayQk+xjVcfggPDBy
         a/j7VBr2WSe64AHLaht6y/xyXGG05GIwnGzz+7yOmB/O+DZwxiYf3UQ77Z2QQ3zMDxCB
         Z04o+WWnC+hSwad1nGImvta3qfpZ/fw6dI3Wbb/9SR7tF5dtj7HCByBJHVY8f8oTeTVL
         cI1y+PKScLNI9ZOx5W/rK9l0omP1FX7a+rwmHfiUWAqyP36r3iszWM1bqKgNEMRReXaU
         KyfjfrVTeuhQRoYoL5dPQKoN9OEJfac7uIyWRaZldArMKa94EgUTp8RWb12ix4SZIP3X
         5Q0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729689055; x=1730293855;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cBfmrlBSfEjkwWoQphvN1hCBGz3UX25x8xMEoPM2ncE=;
        b=q4Xa1GaZcdGkht29V5+AG5YVBiGoxNwvsWAmq3R2ELp5rANoC7duwz1DLPQLEaN1gb
         F4AI5dJF/pfoziT/d66MwH75vealY5YDgHGqVX6eiayuck/FDiQ/pBYrQ5YZxEk8aYHM
         jLs8xDArxU0MKpc+khfMerJxkplsFhxm+2rFdyZ8+l6yHvykGeCe+GMIl7HLYtNBTxjS
         XE9nV8pTCu/g5lixZrofQx/oGxHI5E8La1cv5dGzpZDz/5zKYAd5CLyrtKgwdotcl+kl
         RVYxhRRcsWbn5KQluqh1OvbikOMT60UHBSBYrddDEsiQRSXpZaDXhHG2C/egZdJE7ACa
         qYcA==
X-Forwarded-Encrypted: i=1; AJvYcCXgmO0tkZmAXMKT1nRXWXVr+Snj7mym+aPxv8LPq+sM+eN0p8/Qk5ihEGJqyg4awBsU+WoaW/ia18ZMN/k=@vger.kernel.org, AJvYcCXroMiLYqog9RtZyp54ZNOpAwcV9Laf8uwAE+Vt8hV/KesBOpmTqueVsxmYZzCcSeMwG939Pmh9Ix4We6myTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwddP7cqP2LpLHHi0tLTJ8hLlCHEYwiwWbGhrTgJKRiodUDdsNj
	vE5AHTnF7yA85oEo9dcVn39K62ylWpLPhGRb0gZ+1Gf0GTeEnN6SV/ALUBkjmzE=
X-Google-Smtp-Source: AGHT+IHyCX/G4dY9jaClWdPJvl/6MW58i7NeazRqwhVsO6QgFpKx1veD1AG/MvGzYjSOdXVvYYaMkQ==
X-Received: by 2002:a05:6a21:1191:b0:1d8:d3b4:7a73 with SMTP id adf61e73a8af0-1d978aebeacmr2883458637.4.1729689055333;
        Wed, 23 Oct 2024 06:10:55 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec131391asm6257565b3a.26.2024.10.23.06.10.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2024 06:10:54 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] selftests: livepatch: add test cases of stack_order sysfs
 interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZxjuNBidriSwWw8L@pathway.suse.cz>
Date: Wed, 23 Oct 2024 21:10:38 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A7DB7574-7DD4-4D79-8533-1A8A104EFE24@gmail.com>
References: <20241011151151.67869-1-zhangwarden@gmail.com>
 <20241011151151.67869-2-zhangwarden@gmail.com>
 <ZxjuNBidriSwWw8L@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Petr.
> On Oct 23, 2024, at 20:38, Petr Mladek <pmladek@suse.com> wrote:
>=20
> Please, try to send the next version together with the patch adding
> the "stack_order" attribute.
>=20

Do you mean I should resend the patch of "livepatch: Add stack_order =
sysfs attribute" again with this "livepatch selftest" patch?

Regards.
Wardenjohn.



