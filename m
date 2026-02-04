Return-Path: <live-patching+bounces-1974-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iKPhFe6fgmlgWwMAu9opvQ
	(envelope-from <live-patching+bounces-1974-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 02:25:02 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C73C3E06B1
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 02:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D73593030D20
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 01:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C7C26CE2B;
	Wed,  4 Feb 2026 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ae64J5R6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F00181724
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770168294; cv=none; b=s5sYmzeh26ZKj0yJjR5l2SfgO2nj0PXTM74zeb22a9ReiOBng5j9dsWX9xafMOxk/B4GZs72ueozGtYI+XKBGv+RDl8il3CcWWYvKYooiv0roWenfQoetbA5F1tZlXDh4598mU2ubwMH+wAQX84Epmx5+aWm4YX5gwheX14RoZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770168294; c=relaxed/simple;
	bh=VbMHZphtEQg8ah+CBSQdnIFT1M9d1e1bhM6tMni/x9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSex/aZVqddnzZSR/yosnjRxTy7GxLmmyvPXkF9OwDWEnf7Wj/GL2fd2gUH0b3svJ4jLWKMiVbDo2YpLEGs9sxpWx3FZ/FdF+Pv2A+17QbgUPTUU3iNQXJANQJ4rKENqDtOJne6oGoZr114OEXEadLVABktQOJJ2S9uZ5yGDGEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ae64J5R6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C7EC116D0;
	Wed,  4 Feb 2026 01:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770168294;
	bh=VbMHZphtEQg8ah+CBSQdnIFT1M9d1e1bhM6tMni/x9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ae64J5R6/rElLcYIoMa/7xdWjsGaPDZwLiFpy31VAy1sLAx0TlmMhb26SLnZUn+0Y
	 CUZVZUYPvU03ZKkMS6HuJHt+Wp4coXvjpkDR5yJwDYzQbkqSUe0OMRaBwdl7KSaEo7
	 dZX0jEY56FHAIqMm1oUEW9FIM0LD9oSXh22jfLsBUSCuN1PdmFbYtk+GXmzkQj37EN
	 7N1ifLNRbxPjUZvC96MUsVBIrmdiAHmd6vZrEGUNdi1tbWj5xNwQ+DAT+/SBSnbxwU
	 an7HRRZywnF/P6HaWIPVA4UwisosI+AdCsttEtPjMUeTjx8mV6IOj5OM5kyemSV1ni
	 vvIVAXctvLqyQ==
Date: Tue, 3 Feb 2026 17:24:52 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, kernel-team@meta.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Subject: Re: [PATCH] klp-build: Update demangle_name for LTO
Message-ID: <ojtyhae2qexuvdogiwvja24g7dh7jhe6epl44wupicgigq7qkf@e4t7mvkycex3>
References: <20260203214006.741364-1-song@kernel.org>
 <3rufoy2rjvt4apzwplyn6g6cafrz5hxh2b2ug3cmljndctauo5@bskwjecforne>
 <CAPhsuW7tSyGVBBMOV2bc7gvRXCUbeEETUM7qcZ4HU+Z3D=8SEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7tSyGVBBMOV2bc7gvRXCUbeEETUM7qcZ4HU+Z3D=8SEQ@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1974-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C73C3E06B1
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 04:24:06PM -0800, Song Liu wrote:
> On Tue, Feb 3, 2026 at 3:53 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Tue, Feb 03, 2026 at 01:40:06PM -0800, Song Liu wrote:
> > > With CONFIG_LTO_CLANG_THIN, __UNIQUE_ID_* can be global. Therefore, it
> > > is necessary to demangle global symbols.
> >
> > Ouch, so LTO is changing symbol bindings :-/
> >
> > If a patch causes a symbol to change from LOCAL to GLOBAL between the
> > original and patched builds, that will break some fundamental
> > assumptions in the correlation logic.
> 
> This can indeed happen. A function can be "LOCAL DEFAULT" XXXX
> in original, and "GLOBAL HIDDEN" XXXX.llvm.<hash> in patched.
> 
> I am trying to fix this with incremental steps.
>
> > Also, notice sym->demangled_name isn't used for correlating global
> > symbols in correlate_symbols().  That code currently assumes all global
> > symbols are uniquely named (and don't change between orig and patched).
> > So this first fix seems incomplete.
> 
> We still need to fix correlate_symbols(). I am not 100% sure how to do
> that part yet.
> 
> OTOH, this part still helps. This is because checksum_update_insn()
> uses demangled_name. After the fix, if a function is renamed from
> XXXX to XXXX.llvm.<hash> after the patch, functions that call the
> function are not considered changed.

Hm, wouldn't that still leave the .llvm at the end?

> 
> > > Also, LTO may generate symbols like:
> >
> > The "also" is a clue that this should probably be two separate patches.
> >
> > Also, for objtool patches, please prefix the subject with "objtool:", or
> > in this case, for klp-specific code, "objtool/klp:".
> >
> > > __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar_694_695
> > >
> > > Remove trailing '_' together with numbers and '.' so that both numbers
> > > added to the end of the symbol are removed. For example, the above s
> > > ymbol will be demangled as
> > >
> > > __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar
> >
> > This is indeed a bug in demangle_name(), but not specific to LTO.  The
> > unique number is added by the __UNIQUE_ID() macro.
> >
> > I guess in this case LTO is doing some kind of nested __UNIQUE_ID() to
> > get two "__UNIQUE_ID" strings and two numbers?  But the bug still exists
> > for the non-nested case.
> 
> I don't see nested __UNIQUE_ID() without LTO. Both gcc and clang without
> LTO only sees one level of __UNIQUE_ID.
> 
> With one level of __UNIQUE_ID(), existing code works fine. We just get one
> extra "_" at the end of the demanged_name.

Ah, I see.

-- 
Josh

