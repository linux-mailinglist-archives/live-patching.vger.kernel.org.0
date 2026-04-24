Return-Path: <live-patching+bounces-2548-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIaYGNHt62lHTAAAu9opvQ
	(envelope-from <live-patching+bounces-2548-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:25:21 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F38463CD3
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10A42302D973
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084D733B6F9;
	Fri, 24 Apr 2026 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1mrNXV8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9891337B97
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069489; cv=none; b=iuiF1POqJu2Brkc64m/4lQQFwODC+2Ng8EFsRMa0E9wFA7EtqCy2UOHyeIu+NNJ0Z1N2tZGxCUnd7dp+ERg4AAOTFnu0H8FnOAPnPGeArYNylasy0lo04wQAzjXhnP8Adfk/hBstMwrXpHSfaunqV6NcJ6LFuJ83Q4OAoSMd9rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069489; c=relaxed/simple;
	bh=6pBNOGE4LtT1vxXMTRLGe2IgwbTuyj5IeCuNGGDY5No=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UqfWqs5wyltYIwvvTOAMiu4YcU0I5mo0rlUEmVjazsMvuNbKjR2u5qMz0IJ4pdFKd3TXVCYrViiwknHyqQQfus2UfSH+WP0jRHZf2NBw37fLayYlFW3hWD5LONc5Ftfj/5v51T/Wh33FSWoWCpr9GVyHP9qkMxiMQ0Wi5hqHlYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1mrNXV8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0C7C19425
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777069489;
	bh=6pBNOGE4LtT1vxXMTRLGe2IgwbTuyj5IeCuNGGDY5No=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=D1mrNXV87xS7kJ6MeOuu8UawLqMdprqkm39BiYYWfbhZ5OFIkGfsSmBeLXWNKQpfq
	 z7lPDtdVgICwtoa6pOdw6iSNwJ0hxe5gBjcX43pAaJY4cNZjU6E5i5A9v3zb6IuXDw
	 0HRxc7WD5sIBvAdpfXuNrmpi9/EeeBzOkJak0eeAZ7bBceHnv90W4ldLo6hIN0qaYZ
	 mSgI98+q/IggYeZY3LI1SF/2yXU9t4AIOqj5aWVs3J289wXUply0CkkbIwwS+xi5+9
	 TjDFLyAzUzzp4eUa3GWhY96GjifymILtfRyvJ9CBfhUflv0VjFHo80MXL1lal6ThQi
	 ay3Uz97euOowA==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8a48deebe95so63881626d6.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:24:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/89nwL+8gzSUuucwmg7SUH/1LEeF/PrH2hnEI9kauNw8Uj3IU+wt8eMlfHhgGKkAxLjiiZ5nHgwk4RssVx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5m0q9mfliFwfyujHIW2O27hdv2fbx+zUakAPwiLSiW+i8JDWp
	BSoNCfa46ElAIm3Kafe9fViuy2TtWpHZkrva7CdGu2fTg6JJKWaKRcaK95xIjc/2TAqBWOn0XYb
	NxNrzFgtixHk3x1y/eFQfqAEOVmDzId0=
X-Received: by 2002:a05:6214:5299:b0:8ae:6110:7536 with SMTP id
 6a1803df08f44-8b02807bd25mr503038706d6.19.1777069488692; Fri, 24 Apr 2026
 15:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <99e40357ee24962b3514d9ce4f6e773eff3a15f3.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <99e40357ee24962b3514d9ce4f6e773eff3a15f3.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:24:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4=3ETftzigNSRTZ2ncQUWW7x=DcD56MHytN38s-vnmUg@mail.gmail.com>
X-Gm-Features: AQROBzAtOW-i8lk7nTm8LAEZ6UoQ8HFIwRFh8ytoRKtksdb3MQCg-XEGi9i_i5I
Message-ID: <CAPhsuW4=3ETftzigNSRTZ2ncQUWW7x=DcD56MHytN38s-vnmUg@mail.gmail.com>
Subject: Re: [PATCH 36/48] klp-build: Use "objtool klp checksum" subcommand
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D1F38463CD3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2548-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Use the new "objtool klp checksum" subcommand instead of injecting
> --checksum into every objtool invocation via OBJTOOL_ARGS during the
> kernel build.
>
> This decouples checksum generation from the build, running it in
> separate post-build passes, making the code (and the patch generation
> pipeline itself) more modular.

Having a separate step for checksum removes confusion with
--short-circuit.

>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

