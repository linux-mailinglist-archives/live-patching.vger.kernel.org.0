Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19806DD777
	for <lists+live-patching@lfdr.de>; Tue, 11 Apr 2023 12:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDKKHL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Apr 2023 06:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjDKKGv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Apr 2023 06:06:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB4E30EB;
        Tue, 11 Apr 2023 03:06:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B40D721A0D;
        Tue, 11 Apr 2023 10:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681207604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8n7ywmQ+awe973K1RiYMXZS6nrgeQ28SDo2b1f0miws=;
        b=iQjAp5Plo1DxL4G3EAf2Uv9qUVPzx3RAeN44LQkAv7smbByu3MTFhOjI4+gHxLKJImd/eW
        S+q3SjnKpG86/TkXPkfJJQON2FHhUmUzluJK5BeO6G8JIaB/UNyO9XZWIVe6hS3biBYtqJ
        A15ah9wSpiteBOBddDbZl9Eqa0cncWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681207604;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8n7ywmQ+awe973K1RiYMXZS6nrgeQ28SDo2b1f0miws=;
        b=ZbKtL1u5soy8hRk0Kk3VLkq9oiIES7TTj0sDzvYEh/IS+4YlcKjBfPtemhYJw7VUkaPzg+
        gsCuIFjGO5iLO5Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C57D13638;
        Tue, 11 Apr 2023 10:06:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fSZ3GDQxNWR0PwAAMHmgww
        (envelope-from <nstange@suse.de>); Tue, 11 Apr 2023 10:06:44 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Marcos Paulo de Souza <mpdesouza@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Lukas Hruska <lhruska@suse.cz>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
        <20230314202356.kal22jracaw5442y@daedalus>
        <ZBTNvEPrCcRj3F1C@redhat.com> <20230317232010.7uq6tt4ty35eo5hm@treble>
Date:   Tue, 11 Apr 2023 12:06:43 +0200
In-Reply-To: <20230317232010.7uq6tt4ty35eo5hm@treble> (Josh Poimboeuf's
        message of "Fri, 17 Mar 2023 16:20:10 -0700")
Message-ID: <873556ag24.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Josh Poimboeuf <jpoimboe@kernel.org> writes:

> On Fri, Mar 17, 2023 at 04:29:48PM -0400, Joe Lawrence wrote:
>> Have you tried retrofitting klp-convert into any real-world livepatch?
>> I'm curious as to your observations on the overall experience, or
>> thoughts on the sympos annotation style noted above.
>
> On a related note, the patch creation process (of which klp-convert
> would be part of) needs to be documented.
>
> If I remember correctly, the proper safe usage of klp-convert requires a
> kernel built with -flive-patching, plus some scripting and/or manual
> processes.

Not always, I think: -flive-patching or IPA optimizations in general
aren't a concern in the context of data symbols. From a quick glance, it
seems like the selftests introduced as part of this patchset are
all restricted to this usecase.


> If nobody knows how to safely use it then there wouldn't be much value
> in merging it.

I tend to agree, but would put it a bit differently: the current
implementation of klp-convert features quite some convenience logic,
which, until the question of a documented livepatch preparation process
has been settled, is not known yet to ever be of any use.

For example, from [3/10]:

  "For automatic resolution of livepatch relocations, a file called
   symbols.klp is used. This file maps symbols within every compiled kernel
   object allowing the identification of symbols whose name is unique, thus
   relocation can be automatically inferred, or providing information that
   helps developers when code annotation is required for solving the
   matter."

For the source based approach to livepatch preparation we're using
internally, this is not really needed: the entity generating the source
-- be it klp-ccp or the author doing it manually -- needs to examine the
target objects long before link resp. klp-convert time for which symbols
can be referenced from the livepatch and how (i.e. determine a potential
sympos). I would expect it works similar for kpatch-build conceptually,
albeit kpatch-build probably doesn't rely on any external utility like
klp-convert for the .klp.* relas generation at all.

So with that, I agree that merging the klp-convert patchset in its
current form with those potentially unused convenience features,
presumably born out of certain assumptions about a manual livepatch
preparation process, indeed can be argued about, probably.


However, OTOH, there's currently no means whatsoever to create those
.klp.* relas (*) (**) and I would like to propose resorting to a more
minimal utility doing only that single thing: to stubbornly create
.klp.* relas out of certain "regular" ones using a very simple
transformation rule and nothing else beyond that. The "stripped"
klp-convert would have no knowledge of the symbols available in the
livepatched target objects at all, i.e. there would be no symbols.klp
file or alike anymore. Instead, it would simply walk through all of a
livepatch object's SHN_UNDEF symbols of format
".klp.sym.<loading-obj-name>.<foo-providing-mod>.some_foo,0" somewhen at
modpost time and
- rename the symbol to ".klp.sym.<foo-providing-mod>.some_foo,0" --
  shortening the name should always be feasible as far as strtab is
  concerned.
- turn the symbol's SHN_UNDEF into SHN_LIVEPATCH
- move any relocation (initially created by the compiler with source
  based lp preparation approaches) against this symbol into a separate,
  newly created rela section with flag SHF_RELA_LIVEPATCH set and whose
  name is of format
  .klp.rela.<loading-obj-name>.<livepatch-obj-dst-section-name>.
  Furthermore, the new .klp.rela section's ->sh_info needs to be made to
  refer to the destination section.

So, the only thing which would depend on the yet unspecified details of
the livepatch preparation process would be the creation of those
intermediate
".klp.sym.<loading-obj-name>.<foo-providing-mod>.some_foo,0" SHN_UNDEF
symbols to be processed by klp-convert. For source based livepatch
preparation approaches, counting in the selftests, this can be easily
controlled by means of asm("...") alias specifications at the respective
declarations like in e.g.  extern int foo
asm("\".klp.sym.<loading-obj-name>.<foo-providing-mod>.some_foo,0\"");


I imagine the first ones to benefit from having such a "stripped"
klp-convert available in the kernel tree would be new upstream selftests
for .klp.* rela coverage (like introduced with this here patchset
already) and for those some means of creating .klp.* relas would be
needed anyway. We (SUSE), and perhaps others as well, could integrate
this "stripped" klp-convert into our source based, production livepatch
preparation workflows right away, of course, and so we're obviously keen
on having it. Such a tool providing only the bare minimum would be
pretty much self-contained -- it would only need to hook into the
modpost Kbuild stage one way or the other -- and we could certainly
maintain it downstream out-of-tree, but that would potentially only
contribute to the current fragmentation around the livepatch creation
processes even more and there still wouldn't have a solution for the
upstream selftests.

What do you think, does it make sense to eventually have such a bare
minimum klp-convert merged in-tree, independently of the ongoing
discussion around the livepatch preparation processes, respectively (the
lack of) documentation around it? If yes, Lukas, now on CC, is
interested in this topic and would be willing to help out in any form
desired: either by contributing to Joe's work here or, if deemed more
feasible, to start out completely new from scratch -- dependent on your
opinion on the proposed, more minimal approach as well as on Joe's plans
around klp-convert.

Looking forward to hearing your feedback!

Thanks,

Nicolai

(*) We've been experimenting with building the relocation records
    manually by various means, e.g. with GNU as' .reloc directive as an
    example, but this all turned out impractical for various
    reasons. Most noteworthy, because the records' offsets wouldn't get
    adjusted properly when linking AFAIR.

(**) by some other means than directly with kpatch-build

--=20
SUSE Software Solutions Germany GmbH, Frankenstra=C3=9Fe 146, 90461 N=C3=BC=
rnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
(HRB 36809, AG N=C3=BCrnberg)
