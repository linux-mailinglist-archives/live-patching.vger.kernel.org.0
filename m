Return-Path: <live-patching+bounces-2191-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPc0DWv3sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2191-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:14:51 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE6126B487
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3C6E6302B4FC
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D180D3A16BB;
	Wed, 11 Mar 2026 23:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8q0bowG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC493A16B4
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270889; cv=none; b=NkDy35KnzY8lHSJLnChMWAfzbnN/3u3OM2cNTiaCXbJ/miES5VlQ/gxv9QKWgXGy7yglCm1fPs5kRptPKX240VnRaZIFWVSGugx9LYw3rRNtMkI3HRzLrM2lARUlK7p7oOHc8xRBbE3jDDu3R0plrOV+WLs5fxCttDf0Bht9z0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270889; c=relaxed/simple;
	bh=L2Vb8WWsjbjLZLSdFcWe+vZrR4O/vGefxzNxxS6mHi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dt9WZQvDwrGZXcROATs/+D8GbqESBYksKl/EnZewr6xoY5fxxYMPu77THIVaiUzV5sIk8jzeCaH5nXaTB0c5SEKDO7T0dVgVeEUZQKDzx7UuOBJ1hOGNMN2DNZESNcnbnG8RAVYf8+WG+tAUyEjjOc75D5I06DogqWOaNyVlJfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8q0bowG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61368C4AF0E
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270889;
	bh=L2Vb8WWsjbjLZLSdFcWe+vZrR4O/vGefxzNxxS6mHi4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W8q0bowGnjemJX7uqLPgT1xLErcuBbqz/RuI4rneA5sbik4+m56tYlVnrlh/EFMOD
	 llim9Pk9OTCW+WsrgGb66XhOtC8Cz95CJXZCVgITdPDJ4dOIJli7WumygN8zBx0DWg
	 Q5Jf2L3fVMOhwDRGfwN9CKBlZ+Js0liycYogBE3TJ5NZxRy4K+zjvfk1yOea0uSNZ9
	 xfxCT+pPGKfN1v5P1txy0Sr+EAhaPChUOqq74lh9gGtRJM2Ca6QLMOifDq/aL6hZAc
	 ypN5g+X6QB7yHhRHpiwHXK23e36i+RqLaWS4IKB0Mwnk8PvdMrWXAM0l3QpvVh1/di
	 g/xEvy6xCG1sw==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899ee87355dso5649016d6.1
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:14:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHOF74acAr58Z0tzDnFjWnYUO/TzRc7uDPknBCJRHZTR6H4XjQ28CG7Kp15VfK/B+os6SOd2bSFkrRvHJr@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv/wz9Lh7Bo6BSjLT6qOM0TU+yHGu+obo3pjhlkVpeIG5DXl/Q
	9TENqBkgjQPnxtFQhc25FBDtEA1/uNVdf65xwu1W8fhUUZznAp+oJUFvXhDbvQua6XKz2UsO1Tx
	hEFZOtXodJPu5mQAorYFd9u5n5qMUopw=
X-Received: by 2002:a05:622a:9cd:10b0:509:3f5d:4fb3 with SMTP id
 d75a77b69052e-5093f5d6100mr34675641cf.13.1773270888609; Wed, 11 Mar 2026
 16:14:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <4aaa59736860f593e18e5978ebd56e04e4deea9d.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <4aaa59736860f593e18e5978ebd56e04e4deea9d.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:14:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6pcHSWtz5DaVuv6rVsCvWYbKO11iTGsudnzw0Z95MYRQ@mail.gmail.com>
X-Gm-Features: AaiRm50QscE1g3DpmwkcVcm00gGImnuGoZRqYD-6Lqv8-ehUpmfzOfVXTOxYaiQ
Message-ID: <CAPhsuW6pcHSWtz5DaVuv6rVsCvWYbKO11iTGsudnzw0Z95MYRQ@mail.gmail.com>
Subject: Re: [PATCH 10/14] objtool: Ignore jumps to the end of the function
 for non-CFG arches
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2191-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CEE6126B487
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Sometimes Clang arm64 code jumps to the end of the function for UB.
> No need to make that an error, arm64 doesn't reverse engineer the CFG
> anyway.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

