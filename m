Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84157648863
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 19:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLISWB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 13:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLISWB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 13:22:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A37E09A;
        Fri,  9 Dec 2022 10:22:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C1262300;
        Fri,  9 Dec 2022 18:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104CCC43392;
        Fri,  9 Dec 2022 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670610119;
        bh=oRuHbrET4tyPKkEdzgT2+8zaXtSoNF/Y59VTItF6/tY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bJOM/CemrNI3QfkHchz3Hn0e+8N7Va6vCCPmM8XhBVtH+RUsm4TSnX1p5Yv7HqrkI
         /gXOJwc1aWoaGAt6L3kldJKGVQbHhfTCqAwG9nmFkojlFGVeZ/Dg3PXPGf6nodIrVc
         7YG0hKkZy1L9SKesNhBT5UhnhTKSnyD8EVKF5br+7+84jrG/1WunNONg/L2HbAnoR8
         CGAq66p/4gBEJ8oqGZLWTeyxvtXVIRVHOCxAZf6BcMNU1fC/G9tZnvZaVivk0pzByG
         MYIgli0F5oQ5My1jIzkwmOTwc6y1D+MduSZ2Aald5X3fyNmCmV7DNTSS1z7S3mbmI/
         9p70pcfPtEa/Q==
Received: by mail-ej1-f49.google.com with SMTP id x22so13372302ejs.11;
        Fri, 09 Dec 2022 10:21:58 -0800 (PST)
X-Gm-Message-State: ANoB5pmeJbSsQBhoxh9dlsAyQCW/+5XewY3sbU+a9Syx2ECwC2mAUghP
        IAuWCmy4jMy+CrtynZF+16tUytsKzuK/qTCIawg=
X-Google-Smtp-Source: AA0mqf63HKo2ld9Tzy3TiCXZp5HMXIOF6Ow8FZgiGs0uO/US4vcgX4pFPBfkBqnHxf+N1/NJZwAsyttE0d3IzIjOh/E=
X-Received: by 2002:a17:906:9f09:b0:7bc:db1b:206f with SMTP id
 fy9-20020a1709069f0900b007bcdb1b206fmr16313254ejc.719.1670610117154; Fri, 09
 Dec 2022 10:21:57 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com> <Y5M+AoKHDK4rn6/i@alley>
In-Reply-To: <Y5M+AoKHDK4rn6/i@alley>
From:   Song Liu <song@kernel.org>
Date:   Fri, 9 Dec 2022 10:21:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6nsh4AZNhsE_r91rnHEgeRtuhjSa=5OpWvd5Po1dV9BA@mail.gmail.com>
Message-ID: <CAPhsuW6nsh4AZNhsE_r91rnHEgeRtuhjSa=5OpWvd5Po1dV9BA@mail.gmail.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Dec 9, 2022 at 5:54 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Mon 2022-11-28 17:57:06, Song Liu wrote:
> > On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> > > > --- a/kernel/livepatch/core.c
> > > > +++ b/kernel/livepatch/core.c
> > > > @@ -316,6 +316,45 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> > > >       return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> > > >  }
> > > >
> > > > +static void klp_clear_object_relocations(struct module *pmod,
> > > > +                                     struct klp_object *obj)
> > > > +{
> > > > +     int i, cnt;
> > > > +     const char *objname, *secname;
> > > > +     char sec_objname[MODULE_NAME_LEN];
> > > > +     Elf_Shdr *sec;
> > > > +
> > > > +     objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > > > +
> > > > +     /* For each klp relocation section */
> > > > +     for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> > > > +             sec = pmod->klp_info->sechdrs + i;
> > > > +             secname = pmod->klp_info->secstrings + sec->sh_name;
>
> secname = ...
>
> > > > +             if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
> > > > +                     continue;
> > > > +
> > > > +             /*
> > > > +              * Format: .klp.rela.sec_objname.section_name
> > > > +              * See comment in klp_resolve_symbols() for an explanation
> > > > +              * of the selected field width value.
> > > > +              */
> > > > +             secname = pmod->klp_info->secstrings + sec->sh_name;
>
> secname = ...    same a above.
>
> > > > +             cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
> > > > +             if (cnt != 1) {
> > > > +                     pr_err("section %s has an incorrectly formatted name\n",
> > > > +                            secname);
> > > > +                     continue;
> > > > +             }
> >
> > Actually, I think we don't need the cnt check here. Once it is removed,
> > there isn't much duplicated logic.
>
> Seriously?
>
> A section with this error was skipped in klp_apply_section_relocs().
> I did not cause rejecting the module! Why is it suddenly safe to
> process it, please?

Hmm.. I think you are right, we still need the check.

>
>
> I see that you removed also:
>
>         if (strcmp(objname ? objname : "vmlinux", sec_objname))
>                 return 0;
>
> This is another bug in your "simplification".
>
>
> > > > +
> > > > +             if (strcmp(objname, sec_objname))
> > > > +                     continue;
> > > > +
> > > > +             clear_relocate_add(pmod->klp_info->sechdrs,
> > > > +                                pmod->core_kallsyms.strtab,
> > > > +                                pmod->klp_info->symndx, i, pmod);
> > > > +     }
> > > > +}
> > >
> > > Huh, this duplicates a lot of tricky code.
> > >
> > > It is even worse because this squashed code from two functions
> > > klp_apply_section_relocs() and klp_apply_object_relocs()
> > > into a single function. As a result, the code duplication is not
> > > even obvious.
> > >
> > > Also the suffix "_reloacations() does not match the suffix of
> > > the related funciton:
> > >
> > >         + klp_apply_object_relocs()             (existing)
> > >         + klp_clear_object_relocations()        (new)
> > >
> > > This all would complicate maintenance of the code.
> > >
> > > Please, implement a common:
> > >
> > > int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> > >                              const char *shstrtab, const char *strtab,
> > >                              unsigned int symndx, unsigned int secndx,
> > >                              const char *objname, bool apply);
> > >
> > > and
> > >
> > > int klp_write_object_relocs(struct klp_patch *patch,
> > >                             struct klp_object *obj,
> > >                             bool apply);
> > >
> > > and add the respective wrappers:
> > >
> > > int klp_apply_section_relocs();   /* also needed in module/main.c */
> > > int klp_apply_object_relocs();
> > > void klp_clear_object_relocs();
> >
> > With the above simplification (removing cnt check), do we still need
> > all these wrappers? Personally, I think they will make the code more
> > difficult to follow..
>
> Sigh.
>
> klp_apply_section_relocs() has 25 lines of code.
> klp_apply_object_relocs() has 18 lines of code.
>
> The only difference should be that klp_clear_object_relocs():
>
>    + does not need to call klp_resolve_symbols()
>    + need to call clear_relocate_add() instead of apply_relocate_add()
>
> It is 7 different lines from in the existing 25 + 18 = 43 lines.
> The duplication does not look like a good deal even from this POV.
>
> If we introduce update_relocate_add(..., bool apply) parameter
> then we could call update_relocate_add() in both situations.
>
> Let me repeat from the last mail. klp_clear_object_relocs() even
> reshuffled the duplicated code. It was even harder to find differences.
>
> Do I still need to explain how bad idea was the code duplication,
> please?

No objections that code duplication is not ideal. It is just that sometimes
it is hard to follow the difference between functions with similar names.
Well, it is probably my own problem.

Thanks,
Song
