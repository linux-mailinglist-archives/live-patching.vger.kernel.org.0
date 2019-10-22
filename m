Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B434CDFFE6
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2019 10:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbfJVIp2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Oct 2019 04:45:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:54638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388485AbfJVIp1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Oct 2019 04:45:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96A7EB18B;
        Tue, 22 Oct 2019 08:45:25 +0000 (UTC)
Date:   Tue, 22 Oct 2019 10:45:23 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <20191016123906.GR2328@hirez.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.21.1910221034450.28918@pobox.suse.cz>
References: <20191010091956.48fbcf42@gandalf.local.home> <20191010140513.GT2311@hirez.programming.kicks-ass.net> <20191010115449.22044b53@gandalf.local.home> <20191010172819.GS2328@hirez.programming.kicks-ass.net> <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs> <20191015135634.GK2328@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com> <alpine.LSU.2.21.1910160843420.7750@pobox.suse.cz>
 <20191016123906.GR2328@hirez.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 16 Oct 2019, Peter Zijlstra wrote:

> On Wed, Oct 16, 2019 at 08:51:27AM +0200, Miroslav Benes wrote:
> > On Tue, 15 Oct 2019, Joe Lawrence wrote:
> > 
> > > On 10/15/19 10:13 AM, Miroslav Benes wrote:
> > > > Yes, it does. klp_module_coming() calls module_disable_ro() on all
> > > > patching modules which patch the coming module in order to call
> > > > apply_relocate_add(). New (patching) code for a module can be relocated
> > > > only when the relevant module is loaded.
> > > 
> > > FWIW, would the LPC blue-sky2 model (ie, Steve's suggestion @ plumber's where
> > > livepatches only patch a single object and updates are kept on disk to handle
> > > coming module updates as they are loaded) eliminate those outstanding
> > > relocations and the need to perform this late permission flipping?
> > 
> > Yes, it should, but we don't have to wait for it. PeterZ proposed a 
> > different solution to this specific issue in 
> > https://lore.kernel.org/lkml/20191015141111.GP2359@hirez.programming.kicks-ass.net/
> > 
> > It should not be a problem to create a live patch module like that and the 
> > code in kernel/livepatch/ is almost ready. Something like 
> > module_section_disable_ro(mod, section) (and similar for X protection) 
> > should be enough. Module reloads would still require juggling with the 
> > protections, but I think it is all feasible.
> 
> Something a little like so.. completely fresh of the keyboard.

Yes, but I noticed you found different and better way through text_poke() 
(I was not aware that text_poke() works around the protections).

Miroslav
 
> ---
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -853,6 +853,18 @@ static inline void module_enable_ro(cons
>  static inline void module_disable_ro(const struct module *mod) { }
>  #endif
>  
> +#if defined(CONFIG_STRICT_MODULE_RWX) && defined(CONFIG_LIVEPATCH)
> +extern void module_section_disable_ro(struct module *mod, const char *sec);
> +extern void module_section_enable_ro(struct module *mod, const char *sec);
> +extern void module_section_disable_x(struct module *mod, const char *sec);
> +extern void module_section_enable_x(struct module *mod, const char *sec);
> +#else
> +static inline void module_section_disable_ro(struct module *mod, const char *sec) { }
> +static inline void module_section_enable_ro(struct module *mod, const char *sec) { }
> +static inline void module_section_disable_x(struct module *mod, const char *sec) { }
> +static inline void module_section_enable_x(struct module *mod, const char *sec) { }
> +#endif
> +
>  #ifdef CONFIG_GENERIC_BUG
>  void module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
>  			 struct module *);
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2107,6 +2107,54 @@ static void free_module_elf(struct modul
>  	kfree(mod->klp_info->secstrings);
>  	kfree(mod->klp_info);
>  }
> +
> +#ifdef CONFIG_STRICT_MODULE_RWX
> +
> +static void __frob_section(struct Elf_Shdr *sec, int (*set_memory)(unsigned long start, int num_pages))
> +{
> +	BUG_ON((unsigned long)sec->sh_addr & (PAGE_SIZE-1));
> +	BUG_ON((unsigned long)sec->sh_size & (PAGE_SIZE-1));
> +	set_memory((unsigned long)sec->sh_addr, sec->sh_size >> PAGE_SHIFT);
> +}
> +
> +static void frob_section(struct module *mod, const char *section,
> +			 int (*set_memory)(unsigned long start, int num_pages))
> +{
> +	struct klp_modinfo *info = mod->klp_info;
> +	const char *secname;
> +	Elf_Shdr *s;
> +
> +	for (s = info->sechdrs; s < info->sechdrs + info->hdr.e_shnum; s++) {
> +		secname = mod->klp_info->secstrings + s->sh_name;
> +		if (strcmp(secname, section))
> +			continue;
> +
> +		__frob_section(s, set_memory);
> +	}
> +}
> +
> +void module_section_disable_ro(struct module *mod, const char *section)
> +{
> +	frob_section(mod, section, set_memory_rw);
> +}
> +
> +void module_section_enable_ro(struct module *mod, const char *section)
> +{
> +	frob_section(mod, section, set_memory_ro);
> +}
> +
> +void module_section_disable_x(struct module *mod, const char *section)
> +{
> +	frob_section(mod, section, set_memory_nx);
> +}
> +
> +void module_section_enable_x(struct module *mod, const char *section)
> +{
> +	frob_section(mod, section, set_memory_x);
> +}
> +
> +#endif /* ONFIG_STRICT_MODULE_RWX */
> +
>  #else /* !CONFIG_LIVEPATCH */
>  static int copy_module_elf(struct module *mod, struct load_info *info)
>  {
> 

