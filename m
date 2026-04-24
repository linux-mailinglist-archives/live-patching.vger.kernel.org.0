Return-Path: <live-patching+bounces-2547-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id w39RA1zs62lHTAAAu9opvQ
	(envelope-from <live-patching+bounces-2547-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:19:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 54792463C4C
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F41F300D16D
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDEC248F57;
	Fri, 24 Apr 2026 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahOPQf6B"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FECEEC0
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069144; cv=none; b=bicZd7tQUoNEPGciv0WobdBXLd7Cl3ChCA3VcCvuQdO+VrEviGd1TCXEEaJdxx3vip4uFCoC9pkqyL6KR/RWSJEIuxc40EDN7eeUxjPedhDYaFL3zPmBWbFoPGBVtwYoINGXD+vl+Q0QXJqKqazGeyo9hwWxsG3/IqNC8KUOqvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069144; c=relaxed/simple;
	bh=TrAHvHGLvpzXcdqr4j1W/xnAnR38XVX/cr8Ruc57V0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LzWGPeN0lPXC+M0DfFmlkid+1G72wyeEnAUi+DnFWAQ8X2atMYxWW0YYI1KavBV8aiP5APDeBq830gFTD8vaFPpOXOmtZfYbUNxOoJC9I5Gi81azWBzM6E6+IMFKr7sXhzQDmgFKILRni1wHEynHBM6dNI6nIr3VoFwAkerJTB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahOPQf6B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31802C2BCB6
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777069144;
	bh=TrAHvHGLvpzXcdqr4j1W/xnAnR38XVX/cr8Ruc57V0U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ahOPQf6BuP4nl1fuNidU9PfxxlRvtuQzBRoCumJNYVQjent0Vzu8fHsDMV1W2hL3e
	 2Om4LQ3waHeEZeoctnYOcgVdTAjl7Ez07KcVoN39qaMQWwZoTCqen05YOviL2D171a
	 cOE+UwpY3UYxrZlsEfsbJAxBJWlutN50v5i5RfJuQd+EKjt9AlJvEjeqPT3rhEJ+U4
	 0RAm+mxrJIMczK3jrw3Hf08uNMKqy2816BEgDCoxM5jDDmqCIkwjB9OVs42VJtxfa1
	 EcsUjW+k8vk6Mvw7OGsQUwjhrR7tznGbAtkotQ4oSO/IPKGh25eIXygHf1CEnrt6oW
	 1GMT5McKG2YeQ==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cbc593a67aso769598585a.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:19:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/x4VXSGbwU6M+nRoC59Q+Z9NeO+t1+6l/3SaHF5Q1j0NYZv/UZhEVIsBsrP3i2ezs6FWPxGTHXEHJYO3VM@vger.kernel.org
X-Gm-Message-State: AOJu0YzJDrKHC5smUJusN6t53B3HQPplX/UQDCFr+1c/nAnrWDiD+TOS
	2pxfRm+r/+jlooMI5tKo43Eypfe7pk1JSVCrpTUoF+AVILIHABQokOARLCIs7zZ7htUKTE+5zBg
	irUFdh5GjyFwQti7t5OFPA5wR7le3vBM=
X-Received: by 2002:a05:620a:7083:b0:8cf:c0c9:bca with SMTP id
 af79cd13be357-8e78fe20806mr4782173285a.17.1777069143397; Fri, 24 Apr 2026
 15:19:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <29304d60b4b4949720e3e5a5e6f26196bc29fa07.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <29304d60b4b4949720e3e5a5e6f26196bc29fa07.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:18:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7LdrgrbCp-jfX2NjWOuM3+-ggT7GTHg9Uub1_F6X_xbQ@mail.gmail.com>
X-Gm-Features: AQROBzD_g98bvEbevEFieTUHUbEmeP_DUjM3B1U2A9XCt_e6gxdb6D-HVA6bYOk
Message-ID: <CAPhsuW7LdrgrbCp-jfX2NjWOuM3+-ggT7GTHg9Uub1_F6X_xbQ@mail.gmail.com>
Subject: Re: [PATCH 35/48] objtool/klp: Add "objtool klp checksum" subcommand
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 54792463C4C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2547-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Move the checksum functionality out of the main objtool command into a
> new "objtool klp checksum" subcommand.
>
> This has the benefit of making the code (and the patch generation
> process itself) more modular.
>
> For bisectability, both "objtool --checksum" and "objtool klp checksum"
> work for now.  The former will be removed after klp-build has been
> converted to use the new subcommand.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

