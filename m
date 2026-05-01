Return-Path: <live-patching+bounces-2686-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMtDLo6Y9GnTCgIAu9opvQ
	(envelope-from <live-patching+bounces-2686-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 14:11:58 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F32184AC450
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 14:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9FB42300DE1B
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 12:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B4F3A1686;
	Fri,  1 May 2026 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIJL+2lP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30D350D7D
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777637515; cv=none; b=vFwGQVEr71VqxOEeVtrdWC/7i86PBRCmGjL4ChuD1ZZnqopbO4ddFG20vurSs32K5WQsCrIwwKY67OYkTQBUSK/Vlqm0XOn2W+FX1ZBYS6vgVNPEk5KXDNpO0eyKvo1nCF60f4P6pOyNPXiL3GBeCEiaKcCz+gjpeiXi/nvwYpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777637515; c=relaxed/simple;
	bh=SVvP/ecKODF0zZgyRYxvPHtPshFhLojxvOWyaReHGr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SX5TuzzcMmDPePOCeuiWaHW4nGSvknUNpsb9ycfd+pzRcg9bPt2eV4mw+0jGQ2UKYkY6b6nIzR8A8tWHQGNKn4o+39+IeKhG/4b6UaSBxjuOT3wAnPmeE9kXKheElSHx4wTmejPD80QvZ7JYt51o4ZhCIJqITx1YMbMX1ZRa5Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIJL+2lP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F650C2BCC7
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 12:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777637515;
	bh=SVvP/ecKODF0zZgyRYxvPHtPshFhLojxvOWyaReHGr4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WIJL+2lPYw6u06Y/y3xOuE8P5fEE+5yrPZEuN1nFGF3JEKjLwJGVQpdtvwUd1kNAg
	 GVDNO8amNC00Zg+7jh5IFmhLttvC9O5UELdtKV6hw79E9L6XImK5zFzCrvLsZpJXx6
	 Q8RC3iroYXGLOxxlYnzOvRhr2NZRJxY1z+Sz9tgmZWfpNRLwyPUvXAtboAlHXX7ONC
	 m96rGuRmnPUzVK1iF3AWs17J+nNwSy95YkGFlu+VVeqB8h9f9hi9FBtfEkHwjtPVDF
	 yzL81te2R9qRrHVMQQmGn8xzfa808IwS4/wRlJgWivTfu9yZ9QtIrErV6AOLSyMQ4w
	 zOkxMqoAdEl9Q==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-899d6b7b073so18911956d6.2
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 05:11:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9PAPLgHsKeBaxdExgaznqsGL3MOfVdbYd1VHaLIw1FUxiZp2c95S4mgucaQdRkMvYv4JS0INmRu7gTtGoN@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3pEmuwoJVevXQbU29GKZFIFQQtSrNuAQPVmXsR8eXiN/r5+JX
	ojY/yLp3z17AavV7dzDaikZplZ/0mqYMKBuenyiG4aeMU5iElxnA288jP47HB/6vkO/ThCJjs/j
	1YsWbJ6UnoeJF8n6/5HJaZ3z98JjknIk=
X-Received: by 2002:ad4:5ec8:0:b0:8ac:a6f7:8a70 with SMTP id
 6a1803df08f44-8b3fe732800mr110545006d6.22.1777637514510; Fri, 01 May 2026
 05:11:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <52633c62366f87d9b78ebd77873a08b9ac6d31c8.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <52633c62366f87d9b78ebd77873a08b9ac6d31c8.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 13:11:40 +0100
X-Gmail-Original-Message-ID: <CAPhsuW55WdF+S4ykt+EiyHzpsOaD_evq61c33qTBensGmiqMow@mail.gmail.com>
X-Gm-Features: AVHnY4Ijci4n67xPrGimN-2Vs0uY8cJ72WINHlxdoY60I0d7M3dscyPyySpyXTg
Message-ID: <CAPhsuW55WdF+S4ykt+EiyHzpsOaD_evq61c33qTBensGmiqMow@mail.gmail.com>
Subject: Re: [PATCH v2 48/53] objtool: Add insn_sym() helper
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F32184AC450
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2686-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]

On Fri, May 1, 2026 at 5:09=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Alternative replacement instructions awkwardly have insn->sym set to the
> function they get patched to rather than the symbol (or rather lack
> thereof) they belong to in the file.
>
> This makes it difficult to know where a given instruction actually
> lives.
>
> Add a new insn_sym() helper which preserves the existing semantic of
> insn->sym.  Rename insn->sym to insn->_sym, which contains the actual
> ELF binary symbol (or NULL, for alternative replacements) an instruction
> lives in.
>
> The private insn->_sym value will be needed for a subsequent patch.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

