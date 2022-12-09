Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B3D648291
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 13:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLIMtc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 07:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLIMtb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 07:49:31 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE8955CAB;
        Fri,  9 Dec 2022 04:49:30 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A900B337EB;
        Fri,  9 Dec 2022 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670590169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z0PF6L6bT8F2yAUxeD3fQ98XkB3nRgsmzc0APw/zhms=;
        b=pcHFkCbPUXvxZ+gPlNARE22n9L4dTy2Zl20aC6Dz8fB+sDLJ1gYaJwEfOogRXO/Wf/xODg
        4LHIYnfs31cO6P3cbkvY4mobvowIkZSafKtds7zX/JhKP96BPVf0Ts0nMyiCHshEfx/PIA
        lT/1ZbcMRFxLi8XckCREnrVLpSjeH98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670590169;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z0PF6L6bT8F2yAUxeD3fQ98XkB3nRgsmzc0APw/zhms=;
        b=EZnfLtfqdPSpvIndz/ogrK1bONs7jsx/e0jt4kjHLij69J9q66DioRtIm9RDayNAFjZYQj
        Ulo0yBi/zvfbEuDQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6FE712C142;
        Fri,  9 Dec 2022 12:49:29 +0000 (UTC)
Date:   Fri, 9 Dec 2022 13:49:32 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Song Liu <song@kernel.org>
cc:     Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2212091348090.18933@pobox.suse.cz>
References: <20220901171252.2148348-1-song@kernel.org> <Y3expGRt4cPoZgHL@alley> <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -316,6 +316,45 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> > >       return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> > >  }
> > >
> > > +static void klp_clear_object_relocations(struct module *pmod,
> > > +                                     struct klp_object *obj)
> > > +{
> > > +     int i, cnt;
> > > +     const char *objname, *secname;
> > > +     char sec_objname[MODULE_NAME_LEN];
> > > +     Elf_Shdr *sec;
> > > +
> > > +     objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > > +
> > > +     /* For each klp relocation section */
> > > +     for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> > > +             sec = pmod->klp_info->sechdrs + i;
> > > +             secname = pmod->klp_info->secstrings + sec->sh_name;
> > > +             if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
> > > +                     continue;
> > > +
> > > +             /*
> > > +              * Format: .klp.rela.sec_objname.section_name
> > > +              * See comment in klp_resolve_symbols() for an explanation
> > > +              * of the selected field width value.
> > > +              */
> > > +             secname = pmod->klp_info->secstrings + sec->sh_name;
> > > +             cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
> > > +             if (cnt != 1) {
> > > +                     pr_err("section %s has an incorrectly formatted name\n",
> > > +                            secname);
> > > +                     continue;
> > > +             }
> 
> Actually, I think we don't need the cnt check here. Once it is removed,
> there isn't much duplicated logic.

Because it must have passed the check once already during 
klp_apply_section_relocs()? Yes, perhaps.

Miroslav
