Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED95565C9BD
	for <lists+live-patching@lfdr.de>; Tue,  3 Jan 2023 23:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjACWkX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Jan 2023 17:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbjACWkW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Jan 2023 17:40:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7576FDF55
        for <live-patching@vger.kernel.org>; Tue,  3 Jan 2023 14:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672785572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B09GXReK+nDet8F5ydM15PISVHTTqoDsmKgaENRhmOM=;
        b=Ko6OPXxKEiJEAQrzh8ZCh8cKqcSdu3pq9um6XmRQ/ZoX4Bgr6P8FeM3Zp2UpASCJMUxxo+
        Fx9JUAcybPjGG1CyDK5ybphurJYaliqymsjQA+vAlLAi5t/YiClFoMAnTLlyT7fcdmo+yI
        h9eTE3GeLLdvFcdXTKHcUWuZXH/ZAT4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-tdrWnMl8NZa7jxfm64wr2A-1; Tue, 03 Jan 2023 17:39:31 -0500
X-MC-Unique: tdrWnMl8NZa7jxfm64wr2A-1
Received: by mail-qv1-f70.google.com with SMTP id jh2-20020a0562141fc200b004c74bbb0affso16975969qvb.21
        for <live-patching@vger.kernel.org>; Tue, 03 Jan 2023 14:39:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B09GXReK+nDet8F5ydM15PISVHTTqoDsmKgaENRhmOM=;
        b=WtivzswuZa2KMxEG39Ad8CvR3uRX+eBeoWWIkL+v04uT86YZ4aCeuVrsK31HAeoVoY
         ZnBNviDELi38Wv9Lze5AEJToQpO9IJ3239LbmczikhRCe16hyhE3foMXWVrNCt2/dAnt
         M+DmuD4WEtszabrbtjyiQjD/Rzt3dbENo/B65HBAQU9pYhXh2y2gE1pXcbM8PH1cba5W
         15tga3vncBSgFX+5QbQyFxoJpEEDE0mIu1bEb1k7g/7QIReIV1j1wQoZU2Tyqo87HR5I
         XumwtCMPLJ1eWPmlX/ZFnt1S8lEDLfzj/bttjUvxT5JV7HOl2KpBblXcvSez7PYlsKs/
         B/fQ==
X-Gm-Message-State: AFqh2kqKxoiBaXT8wmHFXl7442TlLz98SlluoMyLcWpDbqmS7KgzZtLw
        Gk6u9stnCYLbUTMnqJnc3TNqtvYixKgDwyGY8OgsXBRkd5GR221/x/4HCggUxuH51S34VqNEI/A
        GrhSwX91oV03VrbJhrmKrzyA8Gw==
X-Received: by 2002:ac8:6882:0:b0:3ab:a3d9:c5c8 with SMTP id m2-20020ac86882000000b003aba3d9c5c8mr27372861qtq.3.1672785569335;
        Tue, 03 Jan 2023 14:39:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvnxSWVVYKRLtBic07azcdPOYPZkoNdGKBGhDzf93FVXTn5V3w6mDO4y+CBuc7F/9IWb1wNDQ==
X-Received: by 2002:ac8:6882:0:b0:3ab:a3d9:c5c8 with SMTP id m2-20020ac86882000000b003aba3d9c5c8mr27372832qtq.3.1672785568851;
        Tue, 03 Jan 2023 14:39:28 -0800 (PST)
Received: from [192.168.1.13] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id g8-20020ac81248000000b003a69de747c9sm19260518qtj.19.2023.01.03.14.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 14:39:28 -0800 (PST)
Message-ID: <23378a2c-aa95-9f6f-6033-f990243cbd7f@redhat.com>
Date:   Tue, 3 Jan 2023 17:39:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>, live-patching@vger.kernel.org
Cc:     jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20221214174035.1012183-1-song@kernel.org>
 <CAPhsuW6tFacM0z3K34eMNZzZmS7UYaa5x8NivrZnySt5sLappQ@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <CAPhsuW6tFacM0z3K34eMNZzZmS7UYaa5x8NivrZnySt5sLappQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/3/23 12:00, Song Liu wrote:
> Hi folks,
> 
> Happy New Year!
> 
> Could you please share your comments/suggestions on this version?
> 

Hi Song,

I recently rebased the klp-convert-v7-devel development branch on top of
upstream v6.1 [1].  That branch includes a bunch of selftests that will
generate klp-relocations for several livepatches.  I started a second
branch, klp-convert-v7-devel-song-v7 [2], which adds a few more commits
to the first one:

1 - (song) livepatch: Clear relocation targets on a module removal -
your v7 patch from this thread

2 - (song, tests) livepatch/selftests: add klp-relocation clearing tests
- modify the selftests to reload modules providing klp-relocation resolution

3 - (song, tests) livepatch/selftests: stricter klp-relocation clearing
tests - modify the selftests to verify that the relocations were
actually cleared

4 - (song, x86_64 suggestions) livepatch: Clear relocation targets on a
module removal - a few option tweaks to the x86 code, which I'll
commentate inline below

5 - (song, ppc64le suggestions, wip) livepatch: Clear relocation targets
on a module removal - a similar attempt at the same for ppc64le code,
which I didn't complete.

[1]
https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v7-devel
[2]
https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v7-devel-song-v7

more inline below ...

> Thanks,
> Song
> 
> On Wed, Dec 14, 2022 at 9:41 AM Song Liu <song@kernel.org> wrote:
>>
>> From: Miroslav Benes <mbenes@suse.cz>
>>
>> Josh reported a bug:
>>
>>   When the object to be patched is a module, and that module is
>>   rmmod'ed and reloaded, it fails to load with:
>>
>>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>>
>>   The livepatch module has a relocation which references a symbol
>>   in the _previous_ loading of nfsd. When apply_relocate_add()
>>   tries to replace the old relocation with a new one, it sees that
>>   the previous one is nonzero and it errors out.
>>
>>   On ppc64le, we have a similar issue:
>>
>>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>>
>> He also proposed three different solutions. We could remove the error
>> check in apply_relocate_add() introduced by commit eda9cec4c9a1
>> ("x86/module: Detect and skip invalid relocations"). However the check
>> is useful for detecting corrupted modules.
>>
>> We could also deny the patched modules to be removed. If it proved to be
>> a major drawback for users, we could still implement a different
>> approach. The solution would also complicate the existing code a lot.
>>
>> We thus decided to reverse the relocation patching (clear all relocation
>> targets on x86_64). The solution is not
>> universal and is too much arch-specific, but it may prove to be simpler
>> in the end.
>>
>> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
>> Signed-off-by: Song Liu <song@kernel.org>
>> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
>> Tested-by: Joe Lawrence <joe.lawrence@redhat.com> # x86_64, s390x, ppc64le

Since there is still some work required for ppc64le and possibly s390x,
let's strip the tested-by tag.  Each version should be re-tested and
then we can let the maintainer add it on the final version.

>>
>> ---
>>
>> NOTE: powerpc32 code is only compile tested.
>>
>> Changes v6 = v7:
>> 1. Reduce code duplication in livepatch/core.c and x86/kernel/module.c.
>> 2. Add more comments to powerpc/kernel/module_64.c.
>> 3. Added Joe's Tested-by (which I should have added in v6).
>>
>> Changes v5 = v6:
>> 1. Fix powerpc64.
>> 2. Fix compile for powerpc32.
>>
>> Changes v4 = v5:
>> 1. Fix compile with powerpc.
>>
>> Changes v3 = v4:
>> 1. Reuse __apply_relocate_add to make it more reliable in long term.
>>    (Josh Poimboeuf)
>> 2. Add back ppc64 logic from v2, with changes to match current code.
>>    (Josh Poimboeuf)
>>
>> Changes v2 => v3:
>> 1. Rewrite x86 changes to match current code style.
>> 2. Remove powerpc changes as there is no test coverage in v3.
>> 3. Only keep 1/3 of v2.
>>
>> v2: https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u
>> ---
>>  arch/powerpc/kernel/module_32.c |  10 +++
>>  arch/powerpc/kernel/module_64.c |  61 ++++++++++++++++++
>>  arch/s390/kernel/module.c       |   8 +++
>>  arch/x86/kernel/module.c        | 108 ++++++++++++++++++++++----------
>>  include/linux/moduleloader.h    |   7 +++
>>  kernel/livepatch/core.c         |  85 ++++++++++++++++---------
>>  6 files changed, 217 insertions(+), 62 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/module_32.c b/arch/powerpc/kernel/module_32.c
>> index ea6536171778..e3c312770453 100644
>> --- a/arch/powerpc/kernel/module_32.c
>> +++ b/arch/powerpc/kernel/module_32.c
>> @@ -285,6 +285,16 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
>>         return 0;
>>  }
>>
>> +#ifdef CONFIG_LIVEPATCH
>> +void clear_relocate_add(Elf32_Shdr *sechdrs,
>> +                  const char *strtab,
>> +                  unsigned int symindex,
>> +                  unsigned int relsec,
>> +                  struct module *me)
>> +{
>> +}
>> +#endif
>> +
>>  #ifdef CONFIG_DYNAMIC_FTRACE
>>  notrace int module_trampoline_target(struct module *mod, unsigned long addr,
>>                                      unsigned long *target)
>> diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
>> index 7e45dc98df8a..83e6c226009c 100644
>> --- a/arch/powerpc/kernel/module_64.c
>> +++ b/arch/powerpc/kernel/module_64.c
>> @@ -739,6 +739,67 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>>         return 0;
>>  }
>>
>> +#ifdef CONFIG_LIVEPATCH
>> +void clear_relocate_add(Elf64_Shdr *sechdrs,
>> +                      const char *strtab,
>> +                      unsigned int symindex,
>> +                      unsigned int relsec,
>> +                      struct module *me)
>> +{
>> +       unsigned int i;
>> +       Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
>> +       Elf64_Sym *sym;
>> +       unsigned long *location;
>> +       const char *symname;
>> +       u32 *instruction;
>> +
>> +       pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
>> +                sechdrs[relsec].sh_info);
>> +
>> +       for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
>> +               location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
>> +                       + rela[i].r_offset;
>> +               sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
>> +                       + ELF64_R_SYM(rela[i].r_info);
>> +               symname = me->core_kallsyms.strtab
>> +                       + sym->st_name;
>> +
>> +               if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
>> +                       continue;

Ppc64le will need to handle additional relocation types.

While debugging a related issue on ppc64le regarding
CONFIG_STRICT_MODULE_RWX [3], these were the extent of the
klp-relocation types generated by kpatch-build and klp-convert-tree:

- R_PPC64_REL24 to symbols in other .text sections
- R_PPC64_ADDR64 to symbols thru .TOC
- R_PPC64_REL64 to static key symbols

I believe R_PPC64_ADDR64 and R_PPC64_REL64 can be simply be reset to 0.

[3] https://github.com/linuxppc/issues/issues/375#issuecomment-1233698835

>> +               /*
>> +                * reverse the operations in apply_relocate_add() for case
>> +                * R_PPC_REL24.
>> +                */
>> +               if (sym->st_shndx != SHN_UNDEF &&
>> +                   sym->st_shndx != SHN_LIVEPATCH)
>> +                       continue;
>> +
>> +               /* skip mprofile and ftrace calls, same as restore_r2() */
>> +               if (is_mprofile_ftrace_call(symname))
>> +                       continue;
>> +
>> +               instruction = (u32 *)location;
>> +               /* skip sibling call, same as restore_r2() */
>> +               if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
>> +                       continue;
>> +
>> +               instruction += 1;
>> +               /*
>> +                * Patch location + 1 back to NOP so the next
>> +                * apply_relocate_add() call (reload the module) will not
>> +                * fail the sanity check in restore_r2():
>> +                *
>> +                *         if (*instruction != PPC_RAW_NOP()) {
>> +                *             pr_err(...);
>> +                *             return 0;
>> +                *         }
>> +                */
>> +               patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
>> +       }
>> +
>> +}
>> +#endif
>> +
>>  #ifdef CONFIG_DYNAMIC_FTRACE
>>  int module_trampoline_target(struct module *mod, unsigned long addr,
>>                              unsigned long *target)
>> diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
>> index 2d159b32885b..cc6784fbc1ac 100644
>> --- a/arch/s390/kernel/module.c
>> +++ b/arch/s390/kernel/module.c
>> @@ -500,6 +500,14 @@ static int module_alloc_ftrace_hotpatch_trampolines(struct module *me,
>>  }
>>  #endif /* CONFIG_FUNCTION_TRACER */
>>
>> +#ifdef CONFIG_LIVEPATCH
>> +void clear_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
>> +                       unsigned int symindex, unsigned int relsec,
>> +                       struct module *me)
>> +{
>> +}
>> +#endif
>> +
>>  int module_finalize(const Elf_Ehdr *hdr,
>>                     const Elf_Shdr *sechdrs,
>>                     struct module *me)
>> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
>> index c032edcd3d95..8f997959e526 100644
>> --- a/arch/x86/kernel/module.c
>> +++ b/arch/x86/kernel/module.c
>> @@ -128,18 +128,20 @@ int apply_relocate(Elf32_Shdr *sechdrs,
>>         return 0;
>>  }
>>  #else /*X86_64*/
>> -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>> +static int __write_relocate_add(Elf64_Shdr *sechdrs,
>>                    const char *strtab,
>>                    unsigned int symindex,
>>                    unsigned int relsec,
>>                    struct module *me,
>> -                  void *(*write)(void *dest, const void *src, size_t len))
>> +                  void *(*write)(void *dest, const void *src, size_t len),
>> +                  bool apply)

Aside: I do prefer the style of one function to handle applying/clearing
of relocations.  x86_64 isn't too bad, but other arches have a much
richer set of relocations that do all sorts of relative/offset/TOC/etc
gymnastics that keeping their code in one spot should be much more
maintainable.

>>  {
>>         unsigned int i;
>>         Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
>>         Elf64_Sym *sym;
>>         void *loc;
>>         u64 val;
>> +       u64 zero = 0ULL;
>>
>>         DEBUGP("Applying relocate section %u to %u\n",
>>                relsec, sechdrs[relsec].sh_info);

How about keying off the apply bool to display "Applying" vs "Clearing".

>> @@ -163,40 +165,60 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>>                 case R_X86_64_NONE:
>>                         break;
>>                 case R_X86_64_64:
>> -                       if (*(u64 *)loc != 0)
>> -                               goto invalid_relocation;
>> -                       write(loc, &val, 8);
>> +                       if (apply) {
>> +                               if (*(u64 *)loc != 0)
>> +                                       goto invalid_relocation;
>> +                               write(loc, &val, 8);
>> +                       } else {
>> +                               write(loc, &zero, 8);
>> +                       }
>>                         break;
>>                 case R_X86_64_32:
>> -                       if (*(u32 *)loc != 0)
>> -                               goto invalid_relocation;
>> -                       write(loc, &val, 4);
>> -                       if (val != *(u32 *)loc)
>> -                               goto overflow;
>> +                       if (apply) {
>> +                               if (*(u32 *)loc != 0)
>> +                                       goto invalid_relocation;
>> +                               write(loc, &val, 4);
>> +                               if (val != *(u32 *)loc)
>> +                                       goto overflow;
>> +                       } else {
>> +                               write(loc, &zero, 4);
>> +                       }
>>                         break;
>>                 case R_X86_64_32S:
>> -                       if (*(s32 *)loc != 0)
>> -                               goto invalid_relocation;
>> -                       write(loc, &val, 4);
>> -                       if ((s64)val != *(s32 *)loc)
>> -                               goto overflow;
>> +                       if (apply) {
>> +                               if (*(s32 *)loc != 0)
>> +                                       goto invalid_relocation;
>> +                               write(loc, &val, 4);
>> +                               if ((s64)val != *(s32 *)loc)
>> +                                       goto overflow;
>> +                       } else {
>> +                               write(loc, &zero, 4);
>> +                       }
>>                         break;
>>                 case R_X86_64_PC32:
>>                 case R_X86_64_PLT32:
>> -                       if (*(u32 *)loc != 0)
>> -                               goto invalid_relocation;
>> -                       val -= (u64)loc;
>> -                       write(loc, &val, 4);
>> +                       if (apply) {
>> +                               if (*(u32 *)loc != 0)
>> +                                       goto invalid_relocation;
>> +                               val -= (u64)loc;
>> +                               write(loc, &val, 4);
>>  #if 0
>> -                       if ((s64)val != *(s32 *)loc)
>> -                               goto overflow;
>> +                               if ((s64)val != *(s32 *)loc)
>> +                                       goto overflow;
>>  #endif

Btw, This has been #if 0'd for so long I wonder if we should just remove it?

>> +                       } else {
>> +                               write(loc, &zero, 4);
>> +                       }
>>                         break;
>>                 case R_X86_64_PC64:
>> -                       if (*(u64 *)loc != 0)
>> -                               goto invalid_relocation;
>> -                       val -= (u64)loc;
>> -                       write(loc, &val, 8);
>> +                       if (apply) {
>> +                               if (*(u64 *)loc != 0)
>> +                                       goto invalid_relocation;
>> +                               val -= (u64)loc;
>> +                               write(loc, &val, 8);
>> +                       } else {
>> +                               write(loc, &zero, 8);
>> +                       }

In my branch [2] ("(song, x86_64 suggestions) livepatch: Clear
relocation targets on a module removal"), I experimented with reducing
these cases down into two steps: compute the new val and then set the
location.

Having back-to-back relocation case blocks wasn't ideal, but it does
reduce code a bit:

  For step 1:
   - combine the relative relocation assignment
   - consider !apply to be val of 0, drop the zero variable

  For step 2:
   - drop the if (apply) conditional, just write the new val

For at least this arch, I think it came out OK.  Summarized here for
reference:

/* Calculate value (or zero if clearing) */
if (apply) {
	val = sym->st_value + rel[i].r_addend;

	switch (ELF64_R_TYPE(rel[i].r_info)) {
	case R_X86_64_PC32:
	case R_X86_64_PLT32:
	case R_X86_64_PC64:
		val -= (u64)loc;
		break;
	}
} else {
	val = 0ULL;
}

/* Apply/clear relocation value */
switch (ELF64_R_TYPE(rel[i].r_info)) {
case R_X86_64_NONE:
	break;
case R_X86_64_64:
	if (apply && *(u64 *)loc != 0)
		goto invalid_relocation;
	write(loc, &val, 8);
	break;
case R_X86_64_32:
	if (apply && *(u32 *)loc != 0)
		goto invalid_relocation;
	write(loc, &val, 4);
	if (val != *(u32 *)loc)
		goto overflow;
	break;
[ ... etc ... ]


That said, things got hairy really fast when I tried applying a similar
pattern to ppc64le code, so maybe this model wouldn't help other arches
so much.  (I haven't looked at s390x yet.)

I'm not married to this approach, but thought I'd mention it as it
helped me tease apart these long apply_relocation() functions.

>>                         break;
>>                 default:
>>                         pr_err("%s: Unknown rela relocation: %llu\n",
>> @@ -219,11 +241,12 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>>         return -ENOEXEC;
>>  }
>>
>> -int apply_relocate_add(Elf64_Shdr *sechdrs,
>> -                  const char *strtab,
>> -                  unsigned int symindex,
>> -                  unsigned int relsec,
>> -                  struct module *me)
>> +static int write_relocate_add(Elf64_Shdr *sechdrs,
>> +                             const char *strtab,
>> +                             unsigned int symindex,
>> +                             unsigned int relsec,
>> +                             struct module *me,
>> +                             bool apply)
>>  {
>>         int ret;
>>         bool early = me->state == MODULE_STATE_UNFORMED;
>> @@ -234,8 +257,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>>                 mutex_lock(&text_mutex);
>>         }
>>
>> -       ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
>> -                                  write);
>> +       ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me,
>> +                                  write, apply);
>>
>>         if (!early) {
>>                 text_poke_sync();
>> @@ -245,6 +268,27 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>>         return ret;
>>  }
>>
>> +int apply_relocate_add(Elf64_Shdr *sechdrs,
>> +                  const char *strtab,
>> +                  unsigned int symindex,
>> +                  unsigned int relsec,
>> +                  struct module *me)
>> +{
>> +       return write_relocate_add(sechdrs, strtab, symindex, relsec, me, true);
>> +}
>> +
>> +#ifdef CONFIG_LIVEPATCH
>> +
>> +void clear_relocate_add(Elf64_Shdr *sechdrs,
>> +                       const char *strtab,
>> +                       unsigned int symindex,
>> +                       unsigned int relsec,
>> +                       struct module *me)
>> +{
>> +       write_relocate_add(sechdrs, strtab, symindex, relsec, me, false);
>> +}
>> +#endif
>> +
>>  #endif
>>
>>  int module_finalize(const Elf_Ehdr *hdr,
>> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
>> index 9e09d11ffe5b..958e6da7f475 100644
>> --- a/include/linux/moduleloader.h
>> +++ b/include/linux/moduleloader.h
>> @@ -72,6 +72,13 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
>>                        unsigned int symindex,
>>                        unsigned int relsec,
>>                        struct module *mod);
>> +#ifdef CONFIG_LIVEPATCH
>> +void clear_relocate_add(Elf_Shdr *sechdrs,
>> +                  const char *strtab,
>> +                  unsigned int symindex,
>> +                  unsigned int relsec,
>> +                  struct module *me);
>> +#endif
>>  #else
>>  static inline int apply_relocate_add(Elf_Shdr *sechdrs,
>>                                      const char *strtab,
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 9ada0bc5247b..8cd04643f988 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -261,6 +261,41 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>>         return 0;
>>  }
>>
>> +static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>> +                                   const char *shstrtab, const char *strtab,
>> +                                   unsigned int symndx, unsigned int secndx,
>> +                                   const char *objname, bool apply)
>> +{
>> +       int cnt, ret;
>> +       char sec_objname[MODULE_NAME_LEN];
>> +       Elf_Shdr *sec = sechdrs + secndx;
>> +
>> +       /*
>> +        * Format: .klp.rela.sec_objname.section_name
>> +        * See comment in klp_resolve_symbols() for an explanation
>> +        * of the selected field width value.
>> +        */
>> +       cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
>> +                    sec_objname);
>> +       if (cnt != 1) {
>> +               pr_err("section %s has an incorrectly formatted name\n",
>> +                      shstrtab + sec->sh_name);
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (strcmp(objname ? objname : "vmlinux", sec_objname))
>> +               return 0;
>> +
>> +       ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
>> +       if (ret)
>> +               return ret;
>> +
>> +       if (apply)
>> +               return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
>> +       clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
>> +       return 0;
>> +}
>> +
>>  /*
>>   * At a high-level, there are two types of klp relocation sections: those which
>>   * reference symbols which live in vmlinux; and those which reference symbols
>> @@ -289,31 +324,8 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>>                              unsigned int symndx, unsigned int secndx,
>>                              const char *objname)
>>  {
>> -       int cnt, ret;
>> -       char sec_objname[MODULE_NAME_LEN];
>> -       Elf_Shdr *sec = sechdrs + secndx;
>> -
>> -       /*
>> -        * Format: .klp.rela.sec_objname.section_name
>> -        * See comment in klp_resolve_symbols() for an explanation
>> -        * of the selected field width value.
>> -        */
>> -       cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
>> -                    sec_objname);
>> -       if (cnt != 1) {
>> -               pr_err("section %s has an incorrectly formatted name\n",
>> -                      shstrtab + sec->sh_name);
>> -               return -EINVAL;
>> -       }
>> -
>> -       if (strcmp(objname ? objname : "vmlinux", sec_objname))
>> -               return 0;
>> -
>> -       ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
>> -       if (ret)
>> -               return ret;
>> -
>> -       return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
>> +       return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
>> +                                       secndx, objname, true);
>>  }
>>
>>  /*
>> @@ -762,8 +774,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>>                            func->old_sympos ? func->old_sympos : 1);
>>  }
>>
>> -static int klp_apply_object_relocs(struct klp_patch *patch,
>> -                                  struct klp_object *obj)
>> +static int klp_write_object_relocs(struct klp_patch *patch,
>> +                                  struct klp_object *obj,
>> +                                  bool apply)
>>  {
>>         int i, ret;
>>         struct klp_modinfo *info = patch->mod->klp_info;
>> @@ -774,10 +787,10 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
>>                 if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
>>                         continue;
>>
>> -               ret = klp_apply_section_relocs(patch->mod, info->sechdrs,
>> +               ret = klp_write_section_relocs(patch->mod, info->sechdrs,
>>                                                info->secstrings,
>>                                                patch->mod->core_kallsyms.strtab,
>> -                                              info->symndx, i, obj->name);
>> +                                              info->symndx, i, obj->name, apply);
>>                 if (ret)
>>                         return ret;
>>         }
>> @@ -785,6 +798,18 @@ static int klp_apply_object_relocs(struct klp_patch *patch,
>>         return 0;
>>  }
>>
>> +static int klp_apply_object_relocs(struct klp_patch *patch,
>> +                                  struct klp_object *obj)
>> +{
>> +       return klp_write_object_relocs(patch, obj, true);
>> +}
>> +
>> +static void klp_clear_object_relocs(struct klp_patch *patch,
>> +                                   struct klp_object *obj)
>> +{
>> +       klp_write_object_relocs(patch, obj, false);
>> +}
>> +
>>  /* parts of the initialization that is done only when the object is loaded */
>>  static int klp_init_object_loaded(struct klp_patch *patch,
>>                                   struct klp_object *obj)
>> @@ -1172,7 +1197,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
>>                         klp_unpatch_object(obj);
>>
>>                         klp_post_unpatch_callback(obj);
>> -
>> +                       klp_clear_object_relocs(patch, obj);
>>                         klp_free_object_loaded(obj);
>>                         break;
>>                 }
>> --
>> 2.30.2
>>
> 

I will try to get around to testing s390x sometime soon and report back
on how that works out.

Thanks,
-- 
Joe

