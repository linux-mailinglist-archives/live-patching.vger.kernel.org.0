Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4C068C583
	for <lists+live-patching@lfdr.de>; Mon,  6 Feb 2023 19:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBFSQa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Feb 2023 13:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBFSQ3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Feb 2023 13:16:29 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DF11DB84;
        Mon,  6 Feb 2023 10:16:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4B10D3F72A;
        Mon,  6 Feb 2023 18:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675707387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VpTAmVky343CE93RylTKOg9+iknURPZdpqszYz0gVWk=;
        b=q3q/IEMraxL+uGTMTRQDzBXNZvh7YJtWYoOjABdD/ulnOAAj1eU41iF3dzZrxlEH7E9XMX
        uuF+ndFgI1CAQsoBT6DhMEE3WYNqMHdcuBrLzfX82P0xuh138VVWd+GBB6hBihAaXu4KA1
        GPHNH9dnxl+xRbPmUcC9z7zOXebhO1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675707387;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VpTAmVky343CE93RylTKOg9+iknURPZdpqszYz0gVWk=;
        b=r5zU8552Q3no+nMApYTLyA79fsqoRBJjCL/55gwpo6z+UBt4msuho8PvIsGzd0mpaMb+3A
        BWDfEgTPykDiHuDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E339E138E7;
        Mon,  6 Feb 2023 18:16:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +k27KflD4WMJRAAAMHmgww
        (envelope-from <mpdesouza@suse.de>); Mon, 06 Feb 2023 18:16:25 +0000
Date:   Mon, 6 Feb 2023 15:16:22 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 03/12] livepatch: Add klp-convert tool
Message-ID: <Y+FD9pCLJUuNKHo2@daedalus.suse.de>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-4-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-4-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 16, 2022 at 11:39:31AM -0500, Joe Lawrence wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>

All the comments bellow are suggestions. Besides them being addressed or not:

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> +
> +/*
> + * User provided sympos annotation checks:
> + * - do two or more elements in usr_symbols have the same object and
> + *   name, but different symbol position
> + * - are there any usr_symbols without a rela?
> + */
> +static bool sympos_sanity_check(struct elf *klp_elf)
> +{
> +	bool sane = true;
> +	struct sympos *sp, *aux;
> +	struct section *sec;
> +	struct rela *rela;
> +
> +	list_for_each_entry(sp, &usr_symbols, list) {
> +		bool found_rela = false;
> +
> +		aux = list_next_entry(sp, list);
> +		list_for_each_entry_from(aux, &usr_symbols, list) {
> +			if (sp->pos != aux->pos &&
> +			    strcmp(sp->object_name, aux->object_name) == 0 &&
> +			    strcmp(sp->symbol_name, aux->symbol_name) == 0) {
> +				WARN("Conflicting KLP_SYMPOS definition: %s.%s,%d vs. %s.%s,%d.",
> +				sp->object_name, sp->symbol_name, sp->pos,
> +				aux->object_name, aux->symbol_name, aux->pos);

The WARN message could be simplified by mentioning the different position,
something like:

	WARN("Conflicting KLP_SYMPOS definition: %s.%s %d vs. %d.",
	sp->object_name, sp->symbol_name, sp->pos aux->pos);


> +				sane = false;
> +			}
> +		}
> +
> +		list_for_each_entry(sec, &klp_elf->sections, list) {
> +			list_for_each_entry(rela, &sec->relas, list) {
> +				if (!strcmp(sp->symbol_name, rela->sym->name)) {
> +					found_rela = true;
> +					break;
> +				}
> +			}
> +		}
> +		if (!found_rela) {
> +			//sane = false;

At this point I believe that sane should be assigned to false to help the user
to know that the specified symbol isn't being used in the livepatch.

> +			WARN("Couldn't find rela for annotated symbol: %s",
> +				sp->symbol_name);
> +		}
> +
> +
> +	}
> +	return sane;
> +}

<snip>


> +/*
> + * Searches for symbol in symbols list and returns its sympos if it is unique,
> + * otherwise prints a list with all considered valid sympos
> + */
> +static struct symbol_entry *find_sym_entry_by_name(char *name)
> +{
> +	struct symbol_entry *found = NULL;
> +	struct symbol_entry *e;
> +
> +	list_for_each_entry(e, &symbols, list) {
> +		if (strcmp(e->symbol_name, name) == 0) {
> +
> +			/*
> +			 * If there exist multiple symbols with the same
> +			 * name then user-provided sympos is required
> +			 */
> +			if (found) {
> +				WARN("Define KLP_SYMPOS for the symbol: %s",
> +						e->symbol_name);
> +
> +				print_valid_module_relocs(name);
> +				return NULL;
> +			}
> +			found = e;
> +		}
> +	}
> +	if (found)
> +		return found;
> +
> +	return NULL;

Since found is either NULL or points to a symbol, the if condition can be
removed and return found directly.

> +}
> +
> +/* Checks if sympos is valid, otherwise prints valid sympos list */
> +static bool valid_sympos(struct sympos *sp)

<snip>
> +
> +/* Returns the right sympos respective to a symbol to be relocated */
> +static bool find_sympos(struct symbol *s, struct sympos *sp)
> +{
> +	struct symbol_entry *entry;
> +	struct converted_sym *cs;
> +
> +	/* did we already convert this symbol? */
> +	list_for_each_entry(cs, &converted_symbols, list) {
> +		if (cs->symbol == s) {
> +			*sp = cs->sympos;
> +			return true;
> +		}
> +	}
> +
> +	/* did the user specified via annotation? */
> +	if (get_usr_sympos(s, sp)) {
> +		if (valid_sympos(sp)) {
> +			remember_sympos(s, sp);
> +			return true;
> +		}
> +		return false;
> +	}
> +
> +	/* search symbol in symbols list */
> +	entry = find_sym_entry_by_name(s->name);
> +	if (entry) {
> +		sp->symbol_name = entry->symbol_name;
> +		sp->object_name = entry->object_name;

At this point I believe that it would be good to have a comment about sympos
being 0 means that the symbol wasn't specified by the user, so sympos 0 means
that the symbol is unique.

> +		sp->pos = 0;
> +		remember_sympos(s, sp);
> +		return true;
> +	}
> +	return false;
> +}

<snip>

 
