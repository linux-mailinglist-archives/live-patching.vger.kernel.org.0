Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9105D6F5F74
	for <lists+live-patching@lfdr.de>; Wed,  3 May 2023 21:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjECTzg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 May 2023 15:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjECTzg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 May 2023 15:55:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487807DB4
        for <live-patching@vger.kernel.org>; Wed,  3 May 2023 12:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683143692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPPlB0tC1J3XZKLrQnNf8x9h7r6zjkjnXzJHQpqmkWs=;
        b=XzKNma2lSv2dOoBu8Bah8mbNFX9Ui1PS69QygzCSx1/Ecpa9erBbUBS2QEjHRVIvc12K5V
        VCZ9SYOJrZeYU2VuHRbvOMfKsIk2xXjzMxjp5z7o2H2rJOdJysZNPRKQrNi13UsY2T/YkK
        8mPmT1/TiqPTJB+CQAceeWEZkfKdDgM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-vdLzX1afPsSMfif7H_Jnqw-1; Wed, 03 May 2023 15:54:51 -0400
X-MC-Unique: vdLzX1afPsSMfif7H_Jnqw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-751409cba6dso323646385a.3
        for <live-patching@vger.kernel.org>; Wed, 03 May 2023 12:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683143690; x=1685735690;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPPlB0tC1J3XZKLrQnNf8x9h7r6zjkjnXzJHQpqmkWs=;
        b=V95kEMquVWvaTGBTs65tIAuV+SEwL05e40Bd79o6BsaPGST7hgF+uK8sycBBD5nR4s
         n9RBaUgq6ASkCu4B295ZbuJMPDN8UXGQmMiaxePTHAECXKbx2UyNx6K4dykjAodZ2IXw
         UVKd6eW5slQ5BQfrNnchGsFzXArfwF/lS+k2A8YAGtZu+D3jvp6KZub8TkjrsaEjJ0uI
         t8frRhOCVB9xXdqcswS4EFLRn5qdDTnN+HKaunNi+4ZgCiHZu3DN1WisyEZa4cNvHVyu
         kj+yiAK8wlsh6V8Ey0QVe6EWYK3fbcB5ZaGxa9LSqCmDZlS4wVLs1KCCpp9oFh6HMYBs
         fxoQ==
X-Gm-Message-State: AC+VfDxINRlFSPKa0anDay3B1uaShfZg6uYpJlZIF28iKhF3Vu54yVSm
        2VGBvx5JXs2mlhWY8xmiSkLojTTWi2xi2xZ2tfD6WTBlYpJkvJS9bk6xU5UeYAq4kSFZ+ITud9C
        uYdz+FslCx5ZdosRJnnBOhFc5pgwpuAzOcg==
X-Received: by 2002:a05:6214:d04:b0:615:53c3:f32a with SMTP id 4-20020a0562140d0400b0061553c3f32amr11123679qvh.42.1683143690431;
        Wed, 03 May 2023 12:54:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4GwCjM/xC2Blwh/pvmH1PC0udjVZqs4dJA9siL/6foyH4pVlanVLHLMixnx1ZDHYH+P4qUAg==
X-Received: by 2002:a05:6214:d04:b0:615:53c3:f32a with SMTP id 4-20020a0562140d0400b0061553c3f32amr11123655qvh.42.1683143690006;
        Wed, 03 May 2023 12:54:50 -0700 (PDT)
Received: from [10.18.17.8] (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f15-20020a05620a280f00b0074df2ac52f8sm11038588qkp.21.2023.05.03.12.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 12:54:49 -0700 (PDT)
Message-ID: <e41b041a-6a9e-210a-bf09-14db2b637e79@redhat.com>
Date:   Wed, 3 May 2023 15:54:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Nicolai Stange <nstange@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Marcos Paulo de Souza <mpdesouza@suse.de>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Lukas Hruska <lhruska@suse.cz>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230314202356.kal22jracaw5442y@daedalus> <ZBTNvEPrCcRj3F1C@redhat.com>
 <20230317232010.7uq6tt4ty35eo5hm@treble> <873556ag24.fsf@suse.de>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
In-Reply-To: <873556ag24.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 4/11/23 06:06, Nicolai Stange wrote:
> Josh Poimboeuf <jpoimboe@kernel.org> writes:
> 
>> On Fri, Mar 17, 2023 at 04:29:48PM -0400, Joe Lawrence wrote:
>>> Have you tried retrofitting klp-convert into any real-world livepatch?
>>> I'm curious as to your observations on the overall experience, or
>>> thoughts on the sympos annotation style noted above.
>>
>> On a related note, the patch creation process (of which klp-convert
>> would be part of) needs to be documented.
>>
>> If I remember correctly, the proper safe usage of klp-convert requires a
>> kernel built with -flive-patching, plus some scripting and/or manual
>> processes.
> 
> Not always, I think: -flive-patching or IPA optimizations in general
> aren't a concern in the context of data symbols. From a quick glance, it
> seems like the selftests introduced as part of this patchset are
> all restricted to this usecase.
> 

IIRC there is nothing currently stopping klp-convert from converting
function symbol relocations.  That may be dangerous when taking
optimizations like sibling functions (and their sharing of stack) into
consideration.  This is about the point I stopped to turn and see what
the real use cases may be.

>> If nobody knows how to safely use it then there wouldn't be much value
>> in merging it.
> 
> I tend to agree, but would put it a bit differently: the current
> implementation of klp-convert features quite some convenience logic,
> which, until the question of a documented livepatch preparation process
> has been settled, is not known yet to ever be of any use.
> 

Good observation and perhaps something that Marcos could elaborate on
(pros and cons of klp-convert in his experiments).

> For example, from [3/10]:
> 
>   "For automatic resolution of livepatch relocations, a file called
>    symbols.klp is used. This file maps symbols within every compiled kernel
>    object allowing the identification of symbols whose name is unique, thus
>    relocation can be automatically inferred, or providing information that
>    helps developers when code annotation is required for solving the
>    matter."
> 
> For the source based approach to livepatch preparation we're using
> internally, this is not really needed: the entity generating the source
> -- be it klp-ccp or the author doing it manually -- needs to examine the
> target objects long before link resp. klp-convert time for which symbols
> can be referenced from the livepatch and how (i.e. determine a potential
> sympos). I would expect it works similar for kpatch-build conceptually,
> albeit kpatch-build probably doesn't rely on any external utility like
> klp-convert for the .klp.* relas generation at all.
> 

Yes the conversion for kpatch-build the conversion is internal, though
split in parts:

The first step is during the binary comparison program
(create-diff-object) to place all the potential klp-relocations into a
temporary .kpatch_relocations section with info like dest, type,
objname, etc.

A second program, either create-klp-module [1] or the mostly deprecated
create-kpatch-module, iterates through the intermediate
.kpatch_relocation sections and converts to klp-relocation in the final
module output.

[1]
https://github.com/dynup/kpatch/blob/master/kpatch-build/create-klp-module.c#L158

> So with that, I agree that merging the klp-convert patchset in its
> current form with those potentially unused convenience features,
> presumably born out of certain assumptions about a manual livepatch
> preparation process, indeed can be argued about, probably.
> 
> 
> However, OTOH, there's currently no means whatsoever to create those
> .klp.* relas (*) (**) and I would like to propose resorting to a more
> minimal utility doing only that single thing: to stubbornly create
> .klp.* relas out of certain "regular" ones using a very simple
> transformation rule and nothing else beyond that. The "stripped"
> klp-convert would have no knowledge of the symbols available in the
> livepatched target objects at all, i.e. there would be no symbols.klp
> file or alike anymore. Instead, it would simply walk through all of a
> livepatch object's SHN_UNDEF symbols of format
> ".klp.sym.<loading-obj-name>.<foo-providing-mod>.some_foo,0" somewhen at
> modpost time and
> - rename the symbol to ".klp.sym.<foo-providing-mod>.some_foo,0" --
>   shortening the name should always be feasible as far as strtab is
>   concerned.
> - turn the symbol's SHN_UNDEF into SHN_LIVEPATCH
> - move any relocation (initially created by the compiler with source
>   based lp preparation approaches) against this symbol into a separate,
>   newly created rela section with flag SHF_RELA_LIVEPATCH set and whose
>   name is of format
>   .klp.rela.<loading-obj-name>.<livepatch-obj-dst-section-name>.
>   Furthermore, the new .klp.rela section's ->sh_info needs to be made to
>   refer to the destination section.
> 

If I understand the idea, it would be similar to the second kpatch-build
step I mentioned above -- nothing fancy, just blindly convert symbols
marked SHN_UNDEF and a given naming convention.

FWIW, it may even be possible to retrofit kpatch-build to the format for
testing -- that would offer the ability to test many real-world CVE fixups.

> So, the only thing which would depend on the yet unspecified details of
> the livepatch preparation process would be the creation of those
> intermediate
> ".klp.sym.<loading-obj-name>.<foo-providing-mod>.some_foo,0" SHN_UNDEF
> symbols to be processed by klp-convert. For source based livepatch
> preparation approaches, counting in the selftests, this can be easily
> controlled by means of asm("...") alias specifications at the respective
> declarations like in e.g.  extern int foo
> asm("\".klp.sym.<loading-obj-name>.<foo-providing-mod>.some_foo,0\"");
> 
> 
> I imagine the first ones to benefit from having such a "stripped"
> klp-convert available in the kernel tree would be new upstream selftests
> for .klp.* rela coverage (like introduced with this here patchset
> already) and for those some means of creating .klp.* relas would be
> needed anyway. We (SUSE), and perhaps others as well, could integrate
> this "stripped" klp-convert into our source based, production livepatch
> preparation workflows right away, of course, and so we're obviously keen
> on having it. Such a tool providing only the bare minimum would be
> pretty much self-contained -- it would only need to hook into the
> modpost Kbuild stage one way or the other -- and we could certainly
> maintain it downstream out-of-tree, but that would potentially only
> contribute to the current fragmentation around the livepatch creation
> processes even more and there still wouldn't have a solution for the
> upstream selftests.
> 
I think you summed it up that having an in-tree user, a test suite at
that, is a good motivation to maintain the conversion tool alongside.
Logistically it may easier to prototype and spin bugfixes faster locally
(esp. if it's supporting a quick CVE mitigation service), but hopefully
the rapid-dev/fix phase is only temporary and the normal upstream-first
development flow prevails.

> What do you think, does it make sense to eventually have such a bare
> minimum klp-convert merged in-tree, independently of the ongoing
> discussion around the livepatch preparation processes, respectively (the
> lack of) documentation around it? If yes, Lukas, now on CC, is
> interested in this topic and would be willing to help out in any form
> desired: either by contributing to Joe's work here or, if deemed more
> feasible, to start out completely new from scratch -- dependent on your
> opinion on the proposed, more minimal approach as well as on Joe's plans
> around klp-convert.
> 

I like the incremental approach of minimizing the complexity of the
conversion tool.  In fact, the hardest parts of this patchset (for me)
revolved around the kbuild integration to generate that symbols file :)
The next hardest where hypothetical problems with resolving to weird
read-only sections and then approaching compiler optimizations.

-- 
Joe

