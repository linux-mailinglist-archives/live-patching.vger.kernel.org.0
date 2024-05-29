Return-Path: <live-patching+bounces-297-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 370CA8D4003
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 23:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20C7288280
	for <lists+live-patching@lfdr.de>; Wed, 29 May 2024 21:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AA91C8FDD;
	Wed, 29 May 2024 21:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZNDbydfL"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B3C1C8FC3
	for <live-patching@vger.kernel.org>; Wed, 29 May 2024 21:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717016667; cv=none; b=T64BMQl0koxodaUhBdoNVjaffqmxGVT+fAL0kFNcdvcvkPu33e2LvOogOnDpG5b60Bj89cXy27tRW04sYfNm+DoZhOyB3CMJdycXphHWshN6KOkC70S6yY/Im0lmajnrw+9sLMTVMWFGsx69jg5YAdLjFEvuEioIPE7O+vETaYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717016667; c=relaxed/simple;
	bh=iMtIvobYI0H9G7tHBc7YyOTeHwx/p57qqvfNbF270pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrZ6xt44b8w2VxCU+XRLpEHpvXoI5oaREFd//6rNYJ/ND+QmomNRFD/TTxS9ltmC8c5rbNFrUWfdYtb6fTZvBQv8WMW7V6QWHLoh5uy77gyi5hcqhf3FimJRIoplK7xsPt0/uyAWWFMk9VrjOnOTHcU0fh9VSDaZfGMppRQ274M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZNDbydfL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717016664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tupnB1YLeLXMhE46LR4yaeakn/pWQ8hjwTVAwcgO5mI=;
	b=ZNDbydfL0GVUWxYXvRIn3gshxSCEZ82ubmlYoSyBb9G8YxCsfUQN8qM6wBpdrbLI/KOW1q
	f2nXoHybNi0SICKcg8+NSiMSCU3XMiFXHjNIeCvvrRLRw2HETeMkwnyclM0LuhgphbVV3q
	gmNvXm5eLlcpIvShn/MxArtBI/EjBrg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-Hki8t8H2MDKypt6_4pUH6g-1; Wed, 29 May 2024 17:04:19 -0400
X-MC-Unique: Hki8t8H2MDKypt6_4pUH6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82DD8016E9;
	Wed, 29 May 2024 21:04:18 +0000 (UTC)
Received: from redhat.com (unknown [10.22.18.140])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AA511C0D100;
	Wed, 29 May 2024 21:04:18 +0000 (UTC)
Date: Wed, 29 May 2024 17:04:16 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: pmladek@suse.com, mbenes@suse.cz, jpoimboe@kernel.org,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, mpdesouza@suse.com,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 2/6] livepatch: Add klp-convert tool
Message-ID: <ZleYUN4z4jizCteM@redhat.com>
References: <20240516133009.20224-1-lhruska@suse.cz>
 <20240516133009.20224-3-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516133009.20224-3-lhruska@suse.cz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Hi Lukas,

As mentioned offlist, reviewing and testing this is on my TODO list, but
here are some early notes ...

On Thu, May 16, 2024 at 03:30:05PM +0200, Lukas Hruska wrote:
> Livepatches need to access external symbols which can't be handled
> by the normal relocation mechanism. It is needed for two types
> of symbols:
> 
>   + Symbols which can be local for the original livepatched function.
>     The alternative implementation in the livepatch sees them
>     as external symbols.
> 
>   + Symbols in modules which are exported via EXPORT_SYMBOL*(). They
>     must be handled special way otherwise the livepatch module would
>     depend on the livepatched one. Loading such livepatch would cause
>     loading the other module as well.
> 
> The address of these symbols can be found via kallsyms. Or they can
> be relocated using livepatch specific relocation sections as specified
> in Documentation/livepatch/module-elf-format.txt.
> 
> Currently, there is no trivial way to embed the required information as
> requested in the final livepatch elf object. klp-convert solves this
> problem by using annotations in the elf object to convert the relocation
> accordingly to the specification, enabling it to be handled by the
> livepatch loader.
> 
> Given the above, create scripts/livepatch to hold tools developed for
> livepatches and add source files for klp-convert there.
> 
> Allow to annotate such external symbols in the livepatch by a macro
> KLP_RELOC_SYMBOL(). It will create symbol with all needed
> metadata. For example:
> 
>   extern char *saved_command_line \
>                  KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0);

Nit: should this be KLP_RELOC_SYMBOL_POS if it including the 0 position?
(Or KLP_RELOC_SYMBOL and omit the implied 0-th position.)

> diff --git a/scripts/livepatch/elf.c b/scripts/livepatch/elf.c
> --- /dev/null
> +++ b/scripts/livepatch/elf.c
> +static int update_shstrtab(struct elf *elf)
> +{
> +	struct section *shstrtab, *sec;
> +	size_t orig_size, new_size = 0, offset, len;
> +	char *buf;
> +
> +	shstrtab = find_section_by_name(elf, ".shstrtab");
> +	if (!shstrtab) {
> +		WARN("can't find .shstrtab");
> +		return -1;
> +	}
> +
> +	orig_size = new_size = shstrtab->size;
> +
> +	list_for_each_entry(sec, &elf->sections, list) {
> +		if (sec->sh.sh_name != ~0U)
> +			continue;
> +		new_size += strlen(sec->name) + 1;
> +	}
> +
> +	if (new_size == orig_size)
> +		return 0;
> +
> +	buf = malloc(new_size);
> +	if (!buf) {
> +		WARN("malloc failed");
> +		return -1;
> +	}
> +	memcpy(buf, (void *)shstrtab->data, orig_size);

While reviewing klp-convert v7 [1], Alexey Dobriyan notes here,

"This code is called realloc(). :-)"

[1] https://lore.kernel.org/live-patching/4ce29654-4e1e-4680-9c25-715823ff5e02@p183/

> +static int update_strtab(struct elf *elf)
> +{
> +	struct section *strtab;
> +	struct symbol *sym;
> +	size_t orig_size, new_size = 0, offset, len;
> +	char *buf;
> +
> +	strtab = find_section_by_name(elf, ".strtab");
> +	if (!strtab) {
> +		WARN("can't find .strtab");
> +		return -1;
> +	}
> +
> +	orig_size = new_size = strtab->size;
> +
> +	list_for_each_entry(sym, &elf->symbols, list) {
> +		if (sym->sym.st_name != ~0U)
> +			continue;
> +		new_size += strlen(sym->name) + 1;
> +	}
> +
> +	if (new_size == orig_size)
> +		return 0;
> +
> +	buf = malloc(new_size);
> +	if (!buf) {
> +		WARN("malloc failed");
> +		return -1;
> +	}
> +	memcpy(buf, (void *)strtab->data, orig_size);

I think Alexey's realloc suggestion would apply here, too.

> +static int write_file(struct elf *elf, const char *file)
> +{
> +	int fd;
> +	Elf *e;
> +	GElf_Ehdr eh, ehout;
> +	Elf_Scn *scn;
> +	Elf_Data *data;
> +	GElf_Shdr sh;
> +	struct section *sec;
> +
> +	fd = creat(file, 0664);
> +	if (fd == -1) {
> +		WARN("couldn't create %s", file);
> +		return -1;
> +	}
> +
> +	e = elf_begin(fd, ELF_C_WRITE, NULL);

Alexy also found an ELF coding bug:

"elf_end() doesn't close descriptor, so there is potentially corrupted
data. There is no unlink() call if writes fail as well."

> +void elf_close(struct elf *elf)
> +{
> +	struct section *sec, *tmpsec;
> +	struct symbol *sym, *tmpsym;
> +	struct rela *rela, *tmprela;
> +
> +	list_for_each_entry_safe(sym, tmpsym, &elf->symbols, list) {
> +		list_del(&sym->list);
> +		free(sym);
> +	}
> +	list_for_each_entry_safe(sec, tmpsec, &elf->sections, list) {
> +		list_for_each_entry_safe(rela, tmprela, &sec->relas, list) {
> +			list_del(&rela->list);
> +			free(rela);
> +		}
> +		list_del(&sec->list);
> +		free(sec);
> +	}
> +	if (elf->fd > 0)
> +		close(elf->fd);

Alexy found another ELF coding bug here:

"Techically, it is "fd >= 0"."


I had coded fixes for these in a v8-devel that I never finished.  It
shouldn't be too hard to fix these up in the minimal version of the
patchset, but lmk if you'd like a patch.

That's all for now.  My plan is to try and turn off kpatch-build's
klp-relocation code and see how passing through to klp-convert fares.
That would give us a good comparison of real-world examples that need to
be handled and tested.

--
Joe


