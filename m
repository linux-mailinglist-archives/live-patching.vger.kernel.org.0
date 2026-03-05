Return-Path: <live-patching+bounces-2107-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GW8CpHrqGnnygAAu9opvQ
	(envelope-from <live-patching+bounces-2107-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 03:33:53 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7AB20A369
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 03:33:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3F1363019C8E
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 02:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E2C257844;
	Thu,  5 Mar 2026 02:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBtjprjB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF0248F47
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 02:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772678030; cv=none; b=cf9t1mULqgEl43bJaUbcalvo+wTNxJwAb2D0U2s2y6e6dQu6t8b+RbIpN1ylTri4SG6A5STRMZEDsBvsvB4soWzNg3vcg85z7OvnvJ+XcOmGxkgJCK8gcunfD5LGzf3OrcouwVOSHf/fSWwQIPb056m2cc5Uu6JdduyKOPKgs6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772678030; c=relaxed/simple;
	bh=As1W44P/HK/8A0K7hvMMxGt3Ni1HUMzr5+gcQ2fFnzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAvl+i/m5WbkctJCUrfMk2V9PNTeGJwbbju3FY3zdJOnuedi0frdt/LGQUqSd0rWk5LNHLcbRsfYBzId1nxHLbG+qm3ZwKzygOhHsNQxNab0ZsyivzKHQ2enLupgbqeJg8TEtJMSsVXL8AG3b9cyoMOCY/gxatLhM99K655lpLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBtjprjB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE2DC4CEF7;
	Thu,  5 Mar 2026 02:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772678030;
	bh=As1W44P/HK/8A0K7hvMMxGt3Ni1HUMzr5+gcQ2fFnzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nBtjprjBBvRdUJ5eBMxtkp4PWNvLhfeY1qUm69Od9nHzBuQqZMbe79Vqcc2d01F/d
	 uivFyTiuazM/YQIXUZ31wrzUYApx8FrHPsMC8cbR2qnpd/x6x5XQ5MCRYcKg6oVW8B
	 QpHLXK+rlz20fFZ3yf35X+9AChbjImjs5ErlAGlW2pPyQZ43pBPY/FbsnsWsI7pXSi
	 g/YXYkRtdrxElFqCMAh7GRDe+y95Wkiz4/QSrK7vuVMIIMFq+XHzhWCeCetRWBi4ib
	 FF8d/2APrbz9tuwIYGXPhVq6c/IAcx+v0TV10Dfzl7AJ1fAtDV/VzfR+kY5WkKY2OD
	 qMRyfJFhbvA6g==
Date: Wed, 4 Mar 2026 18:33:47 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 01/13] objtool/klp: honor SHF_MERGE entry alignment in
 elf_add_data()
Message-ID: <p67ixebt5ufjed44j6wrufwihmsh3ufhbdog7767ro6tygleaw@lvp55v6brjxw>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-2-joe.lawrence@redhat.com>
 <aZST2WmYD-B_o0oc@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZST2WmYD-B_o0oc@redhat.com>
X-Rspamd-Queue-Id: 9C7AB20A369
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2107-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:14:17AM -0500, Joe Lawrence wrote:
> On Tue, Feb 17, 2026 at 11:06:32AM -0500, Joe Lawrence wrote:
> > When adding data to an SHF_MERGE section, set the Elf_Data d_align to
> > the section's sh_addralign so libelf aligns entries within the section.
> > This ensures that entry offsets are consistent with previously calculated
> > relocation addends.
> > 
> > Fixes: 431dbabf2d9d ("objtool: Add elf_create_data()")
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > ---
> >  tools/objtool/elf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> > index 2c02c7b49265..bd6502e7bdc0 100644
> > --- a/tools/objtool/elf.c
> > +++ b/tools/objtool/elf.c
> > @@ -1375,7 +1375,7 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
> >  		memcpy(sec->data->d_buf, data, size);
> >  
> >  	sec->data->d_size = size;
> > -	sec->data->d_align = 1;
> > +	sec->data->d_align = (sec->sh.sh_flags & SHF_MERGE) ? sec->sh.sh_addralign : 1;
> >  
> >  	offset = ALIGN(sec->sh.sh_size, sec->sh.sh_addralign);
> >  	sec->sh.sh_size = offset + size;
> > -- 
> > 2.53.0
> > 
> > 
> 
> This one stretches my ELF internals knowledge a bit, is ^^ true or
> should we rely on the section ".str1.8" suffix to indicate internal
> alignment?

I hit the same issue in my testing for the klp-build arm64 port, I think
it can be simplified to the below?

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
@@ -1375,7 +1382,7 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
 		memcpy(sec->data->d_buf, data, size);
 
 	sec->data->d_size = size;
-	sec->data->d_align = 1;
+	sec->data->d_align = sec->sh.sh_addralign;
 
 	offset = ALIGN(sec->sh.sh_size, sec->sh.sh_addralign);
 	sec->sh.sh_size = offset + size;

