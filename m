Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C786C21FB
	for <lists+live-patching@lfdr.de>; Mon, 20 Mar 2023 20:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjCTTx6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Mar 2023 15:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjCTTxz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Mar 2023 15:53:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5660E38E;
        Mon, 20 Mar 2023 12:53:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5E9C821ABF;
        Mon, 20 Mar 2023 19:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679342012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EpUxLNmwTqpW0BLfBZKQROzzyyfZskZY+ODA7yDR4ts=;
        b=qR5CpGZLQY/SCUQdt4yITkO5T2uYX9sLwpKzKsJeaW0X5Ld9eVytU1ukxQ24t0tmIf4fI0
        uwxYvm1xkTXqUdlGN9GXAv6XCJ7MuBQYW7HgPWlLX+JhsHiSzbWj+fV6xqfMWhGRnf/D+g
        bebXl8LmopGVi20cPt/BZ0Pg2eXjTPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679342012;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EpUxLNmwTqpW0BLfBZKQROzzyyfZskZY+ODA7yDR4ts=;
        b=uF2A3CzqmZcv7MVfoV+Z7vxg3NbycpCcWhG4+gAX89upgjFIJbYjnQQBmeh+nremNWBcIU
        pzWTfup7BsY3STBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D163C13A00;
        Mon, 20 Mar 2023 19:53:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id V8rpJLu5GGSjUAAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Mon, 20 Mar 2023 19:53:31 +0000
Date:   Mon, 20 Mar 2023 16:53:29 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 02/10] livepatch: Add klp-convert tool
Message-ID: <20230320195329.6iptay5bjoaapdvb@daedalus>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230306140824.3858543-3-joe.lawrence@redhat.com>
 <20230314182621.tsh55pjeo6onb6ix@daedalus>
 <b2a6784f-d928-19a8-365f-35fc1e6c617d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2a6784f-d928-19a8-365f-35fc1e6c617d@redhat.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 17, 2023 at 04:06:15PM -0400, Joe Lawrence wrote:
> On 3/14/23 14:26, Marcos Paulo de Souza wrote:
> > On Mon, Mar 06, 2023 at 09:08:16AM -0500, Joe Lawrence wrote:
> >> Livepatches may use symbols which are not contained in its own scope,
> >> and, because of that, may end up compiled with relocations that will
> >> only be resolved during module load. Yet, when the referenced symbols
> >> are not exported, solving this relocation requires information on the
> >> object that holds the symbol (either vmlinux or modules) and its
> >> position inside the object, as an object may contain multiple symbols
> >> with the same name. Providing such information must be done accordingly
> >> to what is specified in Documentation/livepatch/module-elf-format.txt.
> >>
> >> Currently, there is no trivial way to embed the required information as
> >> requested in the final livepatch elf object. klp-convert solves this
> >> problem in two different forms: (i) by relying on symbols.klp, which is
> >> built during kernel compilation, to automatically infer the relocation
> >> targeted symbol, and, when such inference is not possible (ii) by using
> >> annotations in the elf object to convert the relocation accordingly to
> >> the specification, enabling it to be handled by the livepatch loader.
> >>
> >> Given the above, create scripts/livepatch to hold tools developed for
> >> livepatches and add source files for klp-convert there.
> >>
> >> The core file of klp-convert is scripts/livepatch/klp-convert.c, which
> >> implements the heuristics used to solve the relocations and the
> >> conversion of unresolved symbols into the expected format, as defined in
> >> [1].
> >>
> >> klp-convert receives as arguments the symbols.klp file, an input
> >> livepatch module to be converted and the output name for the converted
> >> livepatch. When it starts running, klp-convert parses symbols.klp and
> >> builds two internal lists of symbols, one containing the exported and
> >> another containing the non-exported symbols. Then, by parsing the rela
> >> sections in the elf object, klp-convert identifies which symbols must be
> >> converted, which are those unresolved and that do not have a
> >> corresponding exported symbol, and attempts to convert them accordingly
> >> to the specification.
> >>
> >> By using symbols.klp, klp-convert identifies which symbols have names
> >> that only appear in a single kernel object, thus being capable of
> >> resolving these cases without the intervention of the developer. When
> >> various homonymous symbols exist through kernel objects, it is not
> >> possible to infer the right one, thus klp-convert falls back into using
> >> developer annotations. If these were not provided, then the tool will
> >> print a list with all acceptable targets for the symbol being processed.
> >>
> >> Annotations in the context of klp-convert are accessible as struct
> >> klp_module_reloc entries in sections named .klp.module_relocs.<objname>.
> >> These entries are pairs of symbol references and positions which are to
> >> be resolved against definitions in <objname>.
> >>
> >> Define the structure klp_module_reloc in include/linux/uapi/livepatch.h
> >> allowing developers to annotate the livepatch source code with it.
> >>
> >> klp-convert relies on libelf and on a list implementation. Add files
> >> scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a libelf
> >> interfacing layer and scripts/livepatch/list.h, which is a list
> >> implementation.
> >>
> >> Update Makefiles to correctly support the compilation of the new tool,
> >> update MAINTAINERS file and add a .gitignore file.
> >>
> >> [1] - Documentation/livepatch/module-elf-format.txt
> > 
> > LGTM:
> > 
> > Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > 
> > I only have two remarks:
> > 
> >>
> >> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> >> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> >> Signed-off-by: Joao Moreira <jmoreira@suse.de>
> >> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > 
> > ...
> > 
> > 
> >> +#if 0
> >> +	/*
> >> +	 * klp-relocations forbidden in sections that otherwise would
> >> +	 * match in allowed_prefixes[]
> >> +	 */
> >> +	static const char * const not_allowed[] = {
> >> +		".rela.data.rel.ro",
> >> +		".rela.data.rel.ro.local",
> >> +		".rela.data..ro_after_init",
> >> +		NULL
> >> +	};
> >> +#endif
> >> +
> >> +	/* klp-relocations allowed in sections only for vmlinux */
> >> +	static const char * const allowed_vmlinux[] = {
> >> +		".rela__jump_table",
> >> +		NULL
> >> +	};
> >> +
> >> +	/* klp-relocations allowed in sections with prefixes */
> >> +	static const char * const allowed_prefixes[] = {
> >> +		".rela.data",
> >> +		".rela.rodata",	// supported ???
> >> +		".rela.sdata",
> >> +		".rela.text",
> >> +		".rela.toc",
> >> +		NULL
> >> +	};
> >> +
> >> +	const char * const *name;
> >> +
> >> +#if 0
> >> +	for (name = not_allowed; *name; name++)
> >> +		if (strcmp(sec->name, *name) == 0)
> >> +			return false;
> >> +#endif
> >> +
> > 
> > Have you needed to enable the not_allowed checks when creating your livepatches?
> > Otherwise I believe that this can be removed and added again in the future is
> > needed.
> > 
> 
> Good question.
> 
> I left the disabled blocks in the code as a bookmark for an outstanding
> question: should klp-convert avoid converting relocations in any
> read-only-ish section?
> 
> This becomes interesting in the late module loading case -- some arches
> (ppc64le IIRC) do not like the module loader tweaking these relocations
> post module load. [1]
> 
> In "[PATCH v7 09/10] livepatch/selftests: add data relocations test"
> test_klp_convert_data.c, you'll see a few "// .rela.data.rel.ro,
> .rela.rodata supported ??" comments.  Those would generate relocations
> in such sections.
> 
> Do they *need* to be supported?  AFAIK kpatch-build hasn't needed to
> create any of those.  That said, it's not too difficult for this
> patchset's self-tests to generate these.  klp-convert could easily
> detect this scenario.  The livepatch author could be advised to remove
> const or  __ro_after_init annotation to move the relocation out of the
> read-only-ish section.

I'm not sure if it needs to be supported as well. Maybe other people could give
their inputs in this regard? Suggesting the livepatch author about this case
seems a good option either way.

> 
> [1] https://github.com/joe-lawrence/klp-convert-tree/issues/5
> 
> >> +int main(int argc, const char **argv)
> >> +{
> >> +	const char *klp_in_module, *klp_out_module, *symbols_list;
> > 
> > ...
> > 
> >> +
> >> +/* Functions kept commented since they might be useful for future debugging */
> >> +
> >> +/* Dumps sympos list (useful for debugging purposes)
> >> + * static void dump_sympos(void)
> >> + * {
> >> + *	struct sympos *sp;
> >> + *
> >> + *	fprintf(stderr, "BEGIN OF SYMPOS DUMP\n");
> >> + *	list_for_each_entry(sp, &usr_symbols, list) {
> >> + *		fprintf(stderr, "%s %s %d\n", sp->symbol_name, sp->object_name,
> >> + *				sp->pos);
> >> + *	}
> >> + *	fprintf(stderr, "END OF SYMPOS DUMP\n");
> >> + * }
> >> + *
> >> + *
> >> + * / Dump symbols list for debugging purposes /
> >> + * static void dump_symbols(void)
> >> + * {
> >> + *	struct symbol_entry *entry;
> >> + *
> >> + *	fprintf(stderr, "BEGIN OF SYMBOLS DUMP\n");
> >> + *	list_for_each_entry(entry, &symbols, list)
> >> + *		printf("%s %s\n", entry->object_name, entry->symbol_name);
> >> + *	fprintf(stderr, "END OF SYMBOLS DUMP\n");
> >> + * }
> > 
> > Same here. Have you used these functions recently when debugging klp-convert?
> > Othewise it can be removed as well.
> > 
> 
> I was tinkering with an alternate sympos annotation (I'll describe it in
> a separate reply) and think that these debug routines could be activated
> with --debug cmdline flag(s).  They can be handy for debug/development,
> so better to make them always active rather than #if 0'd out.

Seems a good plan.

> 
> -- 
> Joe
> 
