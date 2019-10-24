Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349FAE31FA
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2019 14:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfJXMNr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Oct 2019 08:13:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:38612 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbfJXMNr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Oct 2019 08:13:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B60EB3D0;
        Thu, 24 Oct 2019 12:13:45 +0000 (UTC)
Date:   Thu, 24 Oct 2019 14:13:44 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] livepatch: Allow to distinguish different version
 of system state changes
Message-ID: <20191024121344.rieej3qckp5xirq6@pathway.suse.cz>
References: <20191003090137.6874-1-pmladek@suse.com>
 <20191003090137.6874-4-pmladek@suse.com>
 <20191023211528.nfstzbuzzxsyffqh@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023211528.nfstzbuzzxsyffqh@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-10-23 16:15:28, Josh Poimboeuf wrote:
> Hi Petr,
> 
> Sorry for taking so long...
> 
> On Thu, Oct 03, 2019 at 11:01:35AM +0200, Petr Mladek wrote:
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > index 726947338fd5..42907c4a0ce8 100644
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> > @@ -133,10 +133,12 @@ struct klp_object {
> >  /**
> >   * struct klp_state - state of the system modified by the livepatch
> >   * @id:		system state identifier (non-zero)
> > + * @version:	version of the change (non-zero)
> 
> Is it necessary to assume that 'version' is non-zero?  It would be easy
> for a user to not realize that and start with version 0.  Then the patch
> state would be silently ignored.
> 
> I have the same concern about 'id', but I guess at least one of them has
> to be non-zero to differentiate valid entries from the array terminator.

Exactly. At least one struct member must be non-zero to differentiate
the array terminator.

I do not mind to allow zero version. Will do so in v4.


> > +/* Check if the patch is able to deal with the given system state. */
> > +static bool klp_is_state_compatible(struct klp_patch *patch,
> > +				    struct klp_state *state)
> > +{
> > +	struct klp_state *new_state;
> > +
> > +	new_state = klp_get_state(patch, state->id);
> > +
> > +	if (new_state)
> > +		return new_state->version >= state->version;
> > +
> > +	/* Cumulative livepatch must handle all already modified states. */
> > +	return !patch->replace;
> > +}
> 
> >From my perspective I view '!new_state' as an error condition.  I'd find
> it easier to read if the ordering were changed to check for the error
> first:
> 
> 	if (!new_state) {
> 		/*
> 		 * A cumulative livepatch must handle all already
> 		 * modified states.
> 		 */
> 		return !patch->replace;
> 	}
> 
> 	return new_state->version >= state->version;

-> v4


> > +
> > +/*
> > + * Check that the new livepatch will not break the existing system states.
> > + * Cumulative patches must handle all already modified states.
> > + * Non-cumulative patches can touch already modified states.
> > + */
> > +bool klp_is_patch_compatible(struct klp_patch *patch)
> > +{
> > +	struct klp_patch *old_patch;
> > +	struct klp_state *state;
> > +
> > +
> > +	klp_for_each_patch(old_patch) {
> 
> Extra newline above.
> 
> > +		klp_for_each_state(old_patch, state) {
> > +			if (!klp_is_state_compatible(patch, state))
> > +				return false;
> > +		}
> > +	}
> 
> I think renaming 'state' to 'old_state' would make the intention a
> little clearer, and would be consistent with 'old_patch'.

Makes sense. I'll make the names consistent also in klp_is_state_compatible():


/* Check if the patch is able to deal with the given system state. */
static bool klp_is_state_compatible(struct klp_patch *patch,
				    struct klp_state *old_state)
{
	struct klp_state *state = klp_get_state(patch, state->id);

	if (!state) {
		/*
		 * A cumulative livepatch must handle all already
		 * modified states.
		 */
		return !patch->replace;
	}

	return state->version >= old_state->version;
}

Best Regards,
Petr
