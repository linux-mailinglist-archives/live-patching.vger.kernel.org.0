Return-Path: <live-patching+bounces-1162-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8F6A3350B
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 02:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84BDD3A6876
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 01:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B1113BC0E;
	Thu, 13 Feb 2025 01:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbKGyBBh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DC5132117
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 01:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739411935; cv=none; b=Qgq5tDlwpmEbTDniLkbw7s5+sDYKsUX1IYSP/fNlXjd3k1mmctdXXdlJrXpL+Lf2NMI69HJn3dF5eMsstfkpEfINsN4br2eAzUGp3fBU/0oa2fFjEyXZWbvPb16q2Wz0Gjz5C6R5gk1eg4YM50/OpxZtk/+nVK5x9Gpxo7UqcSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739411935; c=relaxed/simple;
	bh=SZVDEi3BsXEzZj+xy1CvyBhFWOSXiGDIOio1s1eftec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwtNm1gQxdW1LntmceqNO6xZ2Tfm9PZwPtFd/nQYTd8My7QHFqBUwmZHKulYlAFbx4qyekyLHIdg/YDweT2uDP1j6eWpktElXsaO07YWwP1w18IpfQNcFYy9L3m6oIL3zbYRGUZ1LSlTSzx5Y2Uyi/lyTWzk2tNHJam4ewIPCao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbKGyBBh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB3C4CEDF;
	Thu, 13 Feb 2025 01:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739411935;
	bh=SZVDEi3BsXEzZj+xy1CvyBhFWOSXiGDIOio1s1eftec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbKGyBBhpEE/hd4lE6fO6V9eTdqq62cp1FkVyUF+AMa+Y6dEcMgjfQ0GuQaWadI0j
	 NQ+FVJY7mIpYsB1ClyfxxqpV4X1xmbhdr7bJVnsbYNXgqdiiex00n14Ww0cdLhBwSr
	 bfhv/5/eSLZMxFJ9jYrlgMEoq/Xlww0LXjoaWdrIP2ZhdNCfeLisDYygwvDphyZj1x
	 CQl+fxuGM9qSSKsF5N9fjy7hLqD2xQVSiuLlUgYyZyFi0jAiOOnM9wGkTHibRpdHqJ
	 8EKpB3to2baf5pU3+K6ORBnxs/0Ex4JoIuHRYCGJtz/5osPCgL1pBgFRBci8MK1Ai/
	 5yGFggFl6J/Jg==
Date: Wed, 12 Feb 2025 17:58:52 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3] livepatch: Avoid potential RCU stalls in klp
 transition
Message-ID: <20250213015852.gtsfdwsz4on3i4x2@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-4-laoar.shao@gmail.com>
 <20250212005253.4d6wru5lsrvxch45@jpoimboe>
 <CALOAHbBZ6JGu=39ifyW9Jf8bUwpcBMhr2oe2K2K+wK8VFWo7QA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbBZ6JGu=39ifyW9Jf8bUwpcBMhr2oe2K2K+wK8VFWo7QA@mail.gmail.com>

On Wed, Feb 12, 2025 at 10:42:33AM +0800, Yafang Shao wrote:
> On Wed, Feb 12, 2025 at 8:52 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Tue, Feb 11, 2025 at 02:24:37PM +0800, Yafang Shao wrote:
> > > +++ b/kernel/livepatch/transition.c
> > > @@ -491,9 +491,18 @@ void klp_try_complete_transition(void)
> > >                       complete = false;
> > >                       break;
> > >               }
> > > +
> > > +             /* Avoid potential RCU stalls */
> > > +             if (need_resched()) {
> > > +                     complete = false;
> > > +                     break;
> > > +             }
> > >       }
> > >       read_unlock(&tasklist_lock);
> > >
> > > +     /* The above operation might be expensive. */
> > > +     cond_resched();
> > > +
> >
> > This is also nasty, yet another reason to use rcu_read_lock() if we can.
> 
> The RCU stalls still happen even if we use rcu_read_lock() as it is
> still in the RCU read-side critical section.
> 
> >
> > Also, with the new lazy preemption model, I believe cond_resched() is
> > pretty much deprecated.
> 
> I'm not familiar with the newly introduced PREEMPT_LAZY, but it
> appears to be a configuration option. Therefore, we still need this
> cond_resched() for users who don't have PREEMPT_LAZY set as the
> default.

IIRC, the goal is to get rid of PREEMPT_NONE and PREEMPT_VOLUNTARY (and
PREEMPT_DYNAMIC) and to remove almost all the cond_resched() calls.  So
we should really avoid adding them at this point.

The patch already breaks out of the loop for need_resched(), is the
cond_resched() really needed there?  For the PREEMPT_VOLUNTARY case I
think it should already get preempted anyway when it releases the lock.

And regardless, by that point it's fairly close to scheduling the
delayed work and returning back to the user.  That could happen even
sooner by skipping the "swapper" task loop.

-- 
Josh

